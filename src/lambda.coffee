#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"


ncurry = (n) ->
	helper = (n, acc, f) ->
		return f acc... if n is 0
		(x) ->
			helper n-1, (acc.concat [x]), f
	(f) -> helper n, [], f

curry = ncurry 2

is_hash = (object) ->
	detector = Object.prototype.toString
	(detector.call object) == '[object Object]'

def = (action) ->
	(f, xs) ->
		if arguments.length >= 2
			action f, xs
		else (curry action) f

monoid = (id) -> (op) ->
	#f = def (a, b) ->
		#op a, b
		#if not a? then a = id
		#if not b? then b = id
	f = def op
	f.id = id; f


_ = {}

_.ncurry = ncurry
_.curry = curry

_.map = def (f, xsd) ->
	if is_hash xsd
		_.dict ([k, (f v, k)] for k, v of xsd)
	else f x for x in xsd

_.flat_map = def (f, xs) ->
	_.flatten (_.map f, xs)

_.filter = def (f, xsd) ->
	predicate = ([k, v]) -> f v, k
	if is_hash xsd
		_.dict (_.filter predicate, (_.items xsd))
	else x for x in xsd when f x

_.head = (xs) -> xs[0]
_.tail = (xs) -> xs[1..-1]
_.last = (xs) -> xs[xs.length-1]
_.init = (xs) -> xs[0...-1]

_.take = def (n, xs) ->
	xs[..(n-1)]

_.drop = def (n, xs) ->
	xs[n..]


_.equals = def (a, b) -> a is b

_.positive = (x) -> x > 0
_.negative = (x) -> x < 0

_.push = def (x, xs) ->
	_.concat xs, [x]

_.length = (xsd) ->
	if is_hash xsd
		_.length (_.keys xsd)
	else xsd.length

_.keys = (xd) ->
	k for k, v of xd

_.values = (xd) ->
	v for k, v of xd

_.items = (xd) ->
	[k, v] for k, v of xd

_.dot = def (k, xd) ->
	xd[k]

_.select = def (f, xd) ->
	predicate = ([k, v]) -> f k, v
	_.dict (_.filter predicate, (_.items xd))

_.omit = def (f, xd) ->
	_.select (_.not f), xd

_.contains = def (ks, xsd) ->
	xs = if is_hash xsd
		_.keys xsd
	else xsd
	if typeof ks is 'string'
		ks in xs
	else
		test = (k) -> k in xs
		_.all test, ks

_.in = def (xsd, v) ->
	v in (if is_hash xsd then _.keys xsd else xsd)

_.join = def (v, xs) ->
	xs.join v

_.clone = (obj) ->
	# XXX: JSON.parse(JSON.stringify(xsd))
	# doesn't copies function but may be faster
	if obj is null or typeof obj isnt 'object'
		obj
	else
		copy = obj.constructor()
		for k, v of obj when v?
			copy[k] = _.clone v
		copy

_.reverse = (xs) ->
	(_.clone xs).reverse()

# ==== MONOIDS ====
_.add = (monoid 0) (a, b) ->
	a + b

_.multiply = (monoid 1) (a, b) ->
	a * b

_.concat = (monoid []) (xs, ys) ->
	Array.prototype.concat xs, ys

_.and = (monoid true) (a, b) ->
	a and b

_.or = (monoid false) (a, b) ->
	a or b

_.max = (monoid -Infinity) (a, b) ->
	Math.max(a, b)

_.min = (monoid Infinity) (a, b) ->
	Math.min(a, b)

_.extend = (monoid {}) (a, b) ->
	_.dict (_.reduce _.concat, (_.map _.items, [a, b]))

_.combine = (monoid {}) (a, b) ->
	keys = _.uniq (_.flat_map _.keys, [a, b])
	values = (k) ->
		ak = _.keys a
		bk = _.keys b
		if k in ak and k in bk
			[k, Array.prototype.concat a[k], b[k]]
		else if k in ak
			[k, Array.prototype.concat [], a[k]]
		else if k in bk
			[k, Array.prototype.concat [], b[k]]
		else [k, []]
	_.dict (_.map values, keys)
# ==== END:MONOIDS ====

_.reduce = def (m, xsd) ->
	xs = if is_hash xsd then _.values xsd else xsd
	if not xs.reduce? then return m.id
	if _.length xsd > 0
		xs.reduce m
	else
		xs.reduce m, m.id

# ==== REDUCERS ====
_.sum = (xsd) ->
	_.reduce _.add, xsd

_.product = (xsd) ->
	_.reduce _.multiply, xsd

_.flatten = (xs) ->
	if (is_hash _.head(xs)) and (_.all is_hash, _.filter(_.equals(undefined), xs))
		_.reduce _.extend, xs
	else
		_.reduce _.concat, xs

_.all = def (f, xs) ->
	_.reduce _.and, (_.map f, xs)

_.any = def (f, xs) ->
	_.reduce _.or, (_.map f, xs)

_.biggest = (xs) ->
	_.reduce _.max, xs

_.smallest = (xs) ->
	_.reduce _.min, xs

_.gather = (xs) ->
	_.reduce _.combine, xs

_.sequence = (xs) ->
	keys = _.uniq (_.flat_map _.keys, xs)
	fill = _.fill keys
	reducer = (agg, x) ->
		_.combine (fill agg), (fill x)
	xs.reduce reducer
# ==== END:REDUCERS ====

_.average = (xs) ->
	if (_.length xs) == 0 then 0
	else (_.sum xs) / (_.length xs)

_.not = (f) -> (args...) -> not (f args...)

_.is_number = (n) ->
	(not isNaN (_.float n)) and (isFinite n)

_.sort = (xs) ->
	numbers = (_.map _.number) ((_.filter _.is_number) xs)
	strings = (_.filter (_.not _.is_number)) xs

	sorted_numbers = numbers.sort (a, b) ->
		a - b
	sorted_strings = strings.sort (a, b) ->
		a.localeCompare(b)

	(_.concat sorted_numbers, sorted_strings)

_.pipe = (fs...) -> (a) ->
	flow = (monoid a) (agg, _f) -> _f agg
	_.reduce flow, fs

_.compose = (fs...) ->
	_.pipe (_.reverse fs)...

_.apply = def (f, xs) ->
	f.apply undefined, xs

_.relate = (f, a, b) ->
	action = (f_, a_, b_) ->
		_.map (_.apply f_), _.sequence [a_, b_]
	if arguments.length >= 3
		action f, a, b
	else (a, b) -> action f, a, b

_.group_by = def (f, xs) ->
	result = {}
	for x in xs
		key = f x
		result[key] = result[key] or []
		result[key].push x
	result

_.range = (a, b, step = 1) ->
	if b? then x for x in [a..b] by step
	else [0...a]

_.replace = (a, b) -> (x) ->
	if x is a then b else x

_.uniq = (xs) ->
	f = (x) -> [x, 1]
	_.keys _.dict (_.map f, xs)

_.fill = def (xs, xd) ->
	f = (x) -> [x, null]
	fillers = _.dict (_.map f, xs)
	_.extend fillers, xd

_.dict = (xs) ->
	xd = {}; xd[k] = v for [k, v] in xs; xd

_.def = def

# ==== PARSERS ====
_.id = (x) -> x

_.int = (x) -> parseInt x, 10

_.float = (x) -> parseFloat x, 10

_.number = (x) -> _.float x
# ==== END:PARSERS ====

_.empty = (xsd) ->
	_.length xsd is 0

_.print = (x) ->
	console.log x
	return x
