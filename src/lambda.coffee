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


_ =
	ncurry: ncurry
	curry: curry

	map: def (f, xsd) ->
		if is_hash xsd
			_.dict ([k, (f v, k)] for k, v of xsd)
		else f x for x in xsd

	flat_map: def (f, xs) ->
		_.flatten (_.map f, xs)

	filter: def (f, xsd) ->
		predicate = ([k, v]) -> f v, k
		if is_hash xsd
			_.dict (_.filter predicate, (_.items xsd))
		else x for x in xsd when f x

	head: (xs) -> xs[0]
	tail: (xs) -> xs[1..-1]
	last: (xs) -> xs[xs.length-1]
	init: (xs) -> xs[0...-1]

	take: def (n, xs) ->
		xs[..(n-1)]

	drop: def (n, xs) ->
		xs[n..]


	equals: def (a, b) -> a is b

	positive: (x) -> x > 0
	negative: (x) -> x < 0

	push: def (x, xs) ->
		_.concat xs, [x]

	length: (xsd) ->
		if is_hash xsd
			_.length (_.keys xsd)
		else xsd.length

	keys: (xd) ->
		k for k, v of xd

	values: (xd) ->
		v for k, v of xd

	items: (xd) ->
		[k, v] for k, v of xd

	dot: def (k, xd) ->
		xd[k]

	select: def (f, xd) ->
		predicate = ([k, v]) -> f k, v
		_.dict (_.filter predicate, (_.items xd))

	omit: def (f, xd) ->
		_.select (_.not f), xd

	contains: def (ks, xsd) ->
		xs = if is_hash xsd
			_.keys xsd
		else xsd
		if typeof ks is 'string'
			ks in xs
		else
			test = (k) -> k in xs
			_.all test, ks

	in: def (xsd, v) ->
		v in (if is_hash xsd then _.keys xsd else xsd)

	join: def (v, xs) ->
		xs.join v

	clone: (obj) ->
		# XXX: JSON.parse(JSON.stringify(xsd))
		# doesn't copies function but may be faster
		if obj is null or typeof obj isnt 'object'
			obj
		else
			copy = obj.constructor()
			for k, v of obj when v?
				copy[k] = _.clone v
			copy

	reverse: (xs) ->
		(_.clone xs).reverse()

# ==== MONOIDS ====

	add: (monoid 0) (a, b) ->
		a + b

	multiply: (monoid 1) (a, b) ->
		a * b

	concat: (monoid []) (xs, ys) ->
		Array.prototype.concat xs, ys

	and: (monoid true) (a, b) ->
		a and b

	or: (monoid false) (a, b) ->
		a or b

	max: (monoid -Infinity) (a, b) ->
		Math.max(a, b)

	min: (monoid Infinity) (a, b) ->
		Math.min(a, b)

	extend: (monoid {}) (a, b) ->
		_.dict (_.reduce _.concat, (_.map _.items, [a, b]))

	combine: (monoid {}) (a, b) ->
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
		#values = (k) -> [k, Array.prototype.concat a[k], b[k]]
		_.dict (_.map values, keys)

# ==== END:MONOIDS ====

	# reduce :: (Monoid m) => m -> [a] -> a
	reduce: def (m, xsd) ->
		xs = if is_hash xsd then _.values xsd else xsd
		if not xs.reduce? then return m.id
		if _.length xsd > 0
			xs.reduce m
		else
			xs.reduce m, m.id

# ==== REDUCERS ====

	sum: (xsd) ->
		_.reduce _.add, xsd

	product: (xsd) ->
		_.reduce _.multiply, xsd

	flatten: (xs) ->
		if (is_hash _.head(xs)) and (_.all is_hash, _.filter(_.equals(undefined), xs))
			_.reduce _.extend, xs
		else
			_.reduce _.concat, xs

	all: def (f, xs) ->
		_.reduce _.and, (_.map f, xs)

	any: def (f, xs) ->
		_.reduce _.or, (_.map f, xs)

	biggest: (xs) ->
		_.reduce _.max, xs

	smallest: (xs) ->
		_.reduce _.min, xs

	gather: (xs) ->
		_.reduce _.combine, xs

	sequence: (xs) ->
		keys = _.uniq (_.flat_map _.keys, xs)
		fill = _.fill keys
		reducer = (agg, x) ->
			_.combine (fill agg), (fill x)
		xs.reduce reducer

# ==== END:REDUCERS ====

	average: (xs) ->
		if (_.length xs) == 0 then 0
		else (_.sum xs) / (_.length xs)

	not: (f) -> (args...) -> not (f args...)

	is_number: (n) ->
		(not isNaN (_.float n)) and (isFinite n)

	sort: (xs) ->

		numbers = (_.map _.number) ((_.filter _.is_number) xs)
		strings = (_.filter (_.not _.is_number)) xs

		sorted_numbers = numbers.sort (a, b) ->
			a - b
		sorted_strings = strings.sort (a, b) ->
			a.localeCompare(b)

		(_.concat sorted_numbers, sorted_strings)

	pipe: (fs...) -> (a) ->
		flow = (monoid a) (agg, _f) -> _f agg
		_.reduce flow, fs

	compose: (fs...) ->
		_.pipe (_.reverse fs)...

	apply: def (f, xs) ->
		f.apply undefined, xs

	relate: (f, a, b) ->
		action = (f_, a_, b_) ->
			_.map (_.apply f_), _.sequence [a_, b_]
		if arguments.length >= 3
			action f, a, b
		else (a, b) -> action f, a, b

	group_by: def (f, xs) ->
		result = {}
		for x in xs
			key = f x
			result[key] = result[key] or []
			result[key].push x
		result

	range: (a, b, step = 1) ->
		if b? then x for x in [a..b] by step
		else [0...a]

	replace: (a, b) -> (x) ->
		if x is a then b else x

	uniq: (xs) ->
		f = (x) -> [x, 1]
		_.keys _.dict (_.map f, xs)

	fill: def (xs, xd) ->
		f = (x) -> [x, null]
		fillers = _.dict (_.map f, xs)
		_.extend fillers, xd

	dict: (xs) ->
		xd = {}; xd[k] = v for [k, v] in xs; xd

	def: def

# ==== PARSERS ====
	id: (x) -> x

	int: (x) -> parseInt x, 10

	float: (x) -> parseFloat x, 10

	number: (x) -> _.float x

# ==== END:PARSERS ====

	empty: (xsd) ->
		_.length xsd is 0

	print: (x) ->
		console.log x
		return x
