#!/usr/bin/env lsc

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"


monoid = (id, op) -->
  f = op
  f.id = id; f

type = do ->
  cname = -> it?.constructor?.name
  detect-NaN = -> (cname it) is \Number and (isNaN it)

  ->
    | it is null => \Null
    | it is undefined => \Undefined
    | detect-NaN it => \NaN
    | _ => cname it


is-object  = (is \Object) . type
is-array   = (is \Array)  . type
is-number  = (is \Number) . type
not-number = (is \NaN)    . type


_ = {}

_.type = type
_.is-object = is-object
_.is-array  = is-array


_.dict = ->
  {[k, v] for [k, v]:pair in it}

_.keys = ->
  [k for k, v of it]

_.values = ->
  [v for k, v of it]

_.items = ->
  [[k, v] for k, v of it]


_.map = (f, xs) -->
  [f x for x in xs]

_.map.indexed = (f, xs) -->
  [f x, i for x, i in xs]

_.map.items = (f, kv) -->
  _.dict [f k, v for k, v of kv]

_.map.values = (f, kv) -->
  {[k, (f v, k)] for k, v of kv}

_.map.keys = (f, kv) -->
  {[(f k, v), v] for k, v of kv}

_.map.flat = (f, kv) -->
  _.flatten (_.map f, kv)

_.map.flat.indexed = (f, kv) -->
  _.flatten (_.map.indexed f, kv)


_.filter = (f, xs) -->
  [x for x in xs when f x]

_.filter.values = (f, kv) -->
  predicate = ([k, v]) -> f v, k
  _.dict (_.filter predicate, (_.items kv))

_.filter.keys = (f, kv) -->
  predicate = ([k, v]) -> f k, v
  _.dict (_.filter predicate, (_.items kv))


_.omit = (f, xs) -->
  _.filter (_.not f), xs

_.omit.values = (f, kv) -->
  _.filter.values (_.not f), kv

_.omit.keys = (f, kv) -->
  _.filter.keys (_.not f), kv


_.find = (f, xs) -->
  for x in xs
    if f x then return x

_.find.index = (f, xs) -->
  for x, i in xs when f x
    return i

_.find.keys = (f, kv) -->
  for k, v of kv when f k
    return [k, v]

_.find.values = (f, kv) -->
  for k, v of kv when f v
    return [k, v]

_.find.items = (f, kv) -->
  for k, v of kv when f k, v
    return [k, v]


_.head = --> it.0
_.tail = --> it[1 to -1]
_.last = --> it[* - 1]
_.init = --> it[0 til -1]


_.take = (n, xs) --> xs[til n]

_.take.while = (f, xs) -->
  for x, i in xs when not f x
    return _.take i, xs


_.drop = (n, xs) --> xs[n til]

_.drop.while = (f, xs) -->
  for x, i in xs when not f x
    return _.drop i, xs


_.eq = (a, b) -->
  | not-number a => not-number b
  | _ => a is b

_.gt = (x) -> (> x)
_.ge = (x) -> (>= x)
_.lt = (x) -> (< x)
_.le = (x) -> (<= x)

_.positive = (> 0)
_.negative = (< 0)


_.push = (x, xs) -->
  _.concat xs, [x]


_.length = ->
  | is-object it =>
    it |> _.keys |> _.length
  | is-array  it =>
    it.length
  | _ => 0


_.dot = (k, kv) --> kv[k]

_.dot.path = (ks, kv ? {}) -->
  kv |> _.pipe ...(_.map _.dot, ks)

_.dot.mpath = (...ks) -> (kv) ->
  _.dot.path ks, kv


_.contains = (in)

_.contains.values = (k, kv) -->
  _.contains k, (_.values kv)

_.contains.keys = (k, kv) -->
  _.contains k, (_.keys kv)


_.in = (xs, k) --> (k in xs)

_.in.values = (kv, v) -->
  _.in (_.values kv), v

_.in.keys = (kv, v) -->
  _.in (_.keys kv), v


_.clone = _.copy = ->
  | (is-object it) => {[k, _.copy v] for k, v of it}
  | (is-array  it)  => [_.copy i for i in it]
  | _ => it


_.reverse = _.clone >> (.reverse!)


# ==== MONOIDS ====
_.add      = (monoid 0) (+)
_.multiply = (monoid 1) (*)

_.concat = (monoid []) (a, b) ->
  Array.prototype.concat a, b

_.and = (monoid true) (and)
_.or  = (monoid false) (or)

_.max = (monoid -Infinity) (a, b) --> Math.max a, b
_.min = (monoid  Infinity) (a, b) --> Math.min a, b

_.extend = (monoid {}) (a, b) -->
  [a, b] |> _.map _.items |> _.reduce _.concat |> _.dict

_.combine = (monoid {}) (a, b) -->
  _.gather [a, b]
# ==== END:MONOIDS ====


_.reduce = (m, xs) -->
  | not xs.reduce? => m.id
  | _ => xs.reduce m, m.id

_.reduce.keys = (m, kv) -->
  _.reduce m, (_.keys kv)

_.reduce.values = (m, kv) -->
  _.reduce m, (_.values kv)


# ==== REDUCERS ====
_.sum = (xsd) -->
  _.reduce _.add, xsd

_.product = (xsd) -->
  _.reduce _.multiply, xsd


_.flatten = (xs) -->
  _.reduce _.concat, xs

_.flatten.dict = (kv) -->
  _.reduce _.extend, kv


_.all = (f, xs) -->
  _.reduce _.and, (_.map f, xs)

_.any = (f, xs) -->
  _.reduce _.or, (_.map f, xs)

_.biggest = ->
  _.reduce _.max, it

_.smallest = ->
  _.reduce _.min, it


_.gather = (xs) ->
  ks = _.uniq (_.map.flat _.keys, xs)
  get = (k) ->
    vs = (_.filter (_.contains.keys k)) >> (_.map (_.dot k))
    [k, vs xs]
  _.dict (_.map get, ks)


_.sequence = (xs) -->
  keys = _.uniq (_.map.flat _.keys) xs
  fill = _.fill keys
  _.gather (_.map fill) xs
# ==== END:REDUCERS ====


_.average = ->
  | _.empty it => 0
  | _ => (_.sum it) / (_.length it)


_.sort = (xs) -->
  ...


_.sort.by = (f) --> (xs) -->
  xs.sort f


_.zip = (a, b) -->
    [[ae, be] for ae, i in a when (be = b[i])?]

_.zip.with = (f, a, b) -->
  for ae, i in a when (be = b[i])?
    f ae, be


_.relate = (f, a, b) -->
  [a, b] |> _.sequence |> _.map.values (_.apply f)


_.group_by = (f, xs) -->
  result = {}
  for x in xs
    key = f x
    result[key] = result[key] or []
    result[key].push x
  result


_.range = (a, b, step = 1) -->
  | b? => [a to b by step]
  | _  => [0 til a]


_.replace = (a, b, x) -->
  if x is a then b else x


_.uniq = (xs) -->
  result = []
  for x in xs when x not in result
    result.push x
  result


_.union = (a, b) -->
  _.uniq _.concat a, b


_.intersection = (a, b) -->
  (_.filter (x) -> x in a and x in b) _.union a, b


_.difference = (a, b) -->
  (_.filter (x) -> not (x in a and x in b)) _.union a, b


_.fill = (xs, xd) -->
  _.extend {[x, null] for x in xs}, xd

# ==== PARSERS ====
_.id = -> it


_.int = ->
  | it is false => 0
  | it is true  => 1
  | _ => parseInt x, 10


_.float  = ->
  | it is false => 0.0
  | it is true  => 1.0
  | _ => parseFloat x, 10


_.number = (x) --> _.float x
# ==== END:PARSERS ====

_.empty = -> (_.length it) is 0


_.print = (x) ->
  console.log x
  return x


_.message = (msg, x) -->
  console.log msg, x
  return x


_.log = (f, x) -->
  console.log result = f x
  return result


module.exports = exports = _

