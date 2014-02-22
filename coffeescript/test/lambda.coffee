# This file provides tests for `Lambda` module.

# Importing `assert` from `mocha` node module.

assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

# Importing `Lambda` module itself for testing with handy alias `\_` which allows
# to simplify code.

_ = require '../src/lambda.coffee'


# Helpers

describe 'def', ->
  f = (a, b) -> [a, b]
  h = (a, b, c) -> [a, b, c]
  a = 1; b = 2

  it 'should auto-curry functions', ->
    ((_.def f)(a)(b)).should.be.deep.equal [a, b]
    ((_.def f)(a)(b)).should.be.deep.equal (f a, b)
    ((_.def f)(a, b)).should.be.deep.equal (_.def f)(a)(b)


# Data structures manipulations

describe 'map', ->
  f = (x) -> x + 1
  all_nan = _.all isNaN

  it 'should map function over every element of array', ->
    xs = [1, 2, 3, 4, 5]
    (_.map f, xs).should.deep.equal [2, 3, 4, 5, 6]

  it 'should correctly handle empty arrays', ->
    (_.map f, []).should.deep.equal []

  it 'should not fail if functions returns unexpected values', ->
    (_.map f, ['a']).should.deep.equal ['a1']
    (all_nan _.map f, [undefined]).should.be.true
    (all_nan _.map ((x) -> x / 1), ['a']).should.be.true

  it 'should return empty array if the second argument is not an array', ->
    (_.map f, 1).should.deep.equal []

  it 'should leave resulting array unflattened', ->
    double = (x) -> [x, x]
    (_.map double, [1, 2, 3]).should.deep.equal [[1, 1], [2, 2], [3, 3]]


describe 'map.values', ->
  f = (x) -> x + 1

  it 'should map function over every value of object', ->
    kv = {a: 1, b: 2, c: 3}
    (_.map.values f, kv).should.deep.equal {a: 2, b: 3, c: 4}

  it 'should correctly handle empty objects', ->
    (_.map.values f, {}).should.deep.equal {}

  it 'should return empty object if the second argument is not an object', ->
    (_.map.values f, 1).should.deep.equal {}


describe 'map.keys', ->
  f = (x) -> x + 1

  it 'should map function over every key of object', ->
    kv = {a: 1, b: 2, c: 3}
    (_.map.keys f, kv).should.deep.equal {a1: 1, b1: 2, c1: 3}

  it 'should correctly handle empty objects', ->
    (_.map.keys f, {}).should.deep.equal {}

  it 'should return empty object if the second argument is not an object', ->
    (_.map.keys f, 1).should.deep.equal {}


describe 'map.items', ->
  f = (k, v) -> [k.toUpperCase(), v * v]

  it 'should map function over every key-value pair of object', ->
    kv = {a: 1, b: 2, c: 3}
    (_.map.items f, kv).should.deep.equal {A: 1, B: 4, C: 9}

  it 'should correctly handle empty objects', ->
    (_.map.items f, {}).should.deep.equal {}

  it 'should return empty object if the second argument is not an object', ->
    (_.map.items f, 1).should.deep.equal {}


describe 'map.flat', ->
  xs = [1, 2, 3]
  f = (x) -> [x, x]

  it 'should map function over every element of array and flatten resulting list', ->
    (_.map.flat f, xs).should.deep.equal [1, 1, 2, 2, 3, 3]

  it 'should be equivalent of composing `flatten` and `map`', ->
    (_.map.flat f, xs).should.deep.equal (_.compose _.flatten, _.map f) (xs)


describe 'filter', ->
  xs = [-2, -1, 0, 1, 2]
  even = (x) -> x % 2 == 0

  it 'should clear an array from elements that do not match the predicate', ->
    (_.filter _.positive, xs).should.deep.equal [1, 2]
    (_.filter even, xs).should.deep.equal [-2, 0, 2]

  it 'should return empty array if empty array or object given as an argument', ->
    (_.filter _.positive, []).should.deep.equal []


describe 'filter.values', ->
  kv = {a: -1, b: 0, c: 1}

  it 'should select all key-value pairs from array which value mathes given predicate', ->
    (_.filter.values _.positive, kv).should.deep.equal {c: 1}


describe 'filter.keys', ->
  kv = {a: -1, b: 0, c: 1}
  f = (k) -> k in ['a', 'b']

  it 'should select all key-value pairs from array which key mathes given predicate', ->
    (_.filter.keys f, kv).should.deep.equal {a: -1, b: 0}


describe 'zip', ->

  it 'should zip two lists together resulting in list of pairs', ->
    (_.zip [1, 2, 3], [3, 2, 1]).should.be.deep.equal [[1, 3], [2, 2], [3, 1]]

  it 'should descard leftover elements from the longer input list', ->
    (_.zip [1, 2], [3, 2, 1]).should.be.deep.equal [[1, 3], [2, 2]]
    (_.zip [1, 2, 3], [3, 2]).should.be.deep.equal [[1, 3], [2, 2]]


describe 'zip.with', ->

  it 'should zip two lists together resulting in list of pairs and apply a function to each pair', ->
    (_.zip.with _.add, [1, 2, 3], [3, 2, 1]).should.be.deep.equal [4, 4, 4]

  it 'should descard leftover elements from the longer input list', ->
    (_.zip.with _.add, [1, 2], [3, 2, 1]).should.be.deep.equal [4, 4]
    (_.zip.with _.add, [1, 2, 3], [3, 2]).should.be.deep.equal [4, 4]


describe 'uniq', ->
  xs = [1, 2, 3, 'foo', 3, 'foo', 'bar']

  it 'should return a set of uniq elements of list', ->
    (_.uniq xs).should.be.deep.equal [1, 2, 3, 'foo', 'bar']


describe 'intersection', ->
  a = [1, 2, 3, 'foo']
  b = [3, 'foo', 'bar']

  it 'should return a set of element present in both given sets', ->
    (_.intersection a, b).should.be.deep.equal [3, 'foo']


describe 'diffrenect', ->
  a = [1, 2, 3, 'foo']
  b = [3, 'foo', 'bar']

  it 'should return a set of elements present in both given sets', ->
    (_.difference a, b).should.be.deep.equal [1, 2, 'bar']


describe 'omit', ->
  xs = [-2, -1, 0, 1, 2]
  even = (x) -> x % 2 == 0

  it 'should clear an array from elements that match the predicate', ->
    (_.omit _.positive, xs).should.deep.equal [-2, -1, 0]
    (_.omit even, xs).should.deep.equal [-1, 1]

  it 'should return empty array if empty array or object given as an argument', ->
    (_.omit _.positive, []).should.deep.equal []


describe 'omit.values', ->
  kv = {a: -1, b: 0, c: 1}

  it 'should omit all key-value pairs from array which value mathes given predicate', ->
    (_.omit.values _.positive, kv).should.deep.equal {a: -1, b: 0}


describe 'omit.keys', ->
  kv = {a: -1, b: 0, c: 1}
  f = (k) -> k in ['a', 'b']

  it 'should omit all key-value pairs from array which key mathes given predicate', ->
    (_.omit.keys f, kv).should.deep.equal {c: 1}


describe 'find', ->
  xs = [-2, -1, 0, 4, 5]

  it 'should return first element that satisfies given predicate', ->
    (_.find _.positive, xs).should.equal 4

  it 'should return undefined if none of the elements complies', ->
    expect(_.find _.positive, [-1, -2, 0]).to.equal undefined


describe 'find.keys', ->
  kv = {a: 1, b: 2, c: 3}

  it 'should return first element that satisfies given predicate', ->
    (_.find.keys (_.equals 'a'), kv).should.deep.equal ['a', 1]

  it 'should return undefined if none of the elements complies', ->
    expect(_.find.keys (_.equals 'f'), kv).to.equal undefined


describe 'find.values', ->
  kv = {a: 1, b: 2, c: 3}

  it 'should return first element that satisfies given predicate', ->
    (_.find.values (_.equals 3), kv).should.deep.equal ['c', 3]

  it 'should return undefined if none of the elements complies', ->
    expect(_.find.values (_.equals 5), kv).to.equal undefined


describe 'find.items', ->
  kv = {a: 1, b: 2, c: 3, d: 'd'}
  foo = (k, v) -> k is v

  it 'should return first element that satisfies given predicate', ->
    (_.find.items foo, kv).should.deep.equal ['d', 'd']

  it 'should return undefined if none of the elements complies', ->
    expect(_.find.items (_.gt 5), kv).to.equal undefined


describe 'contains', -> 
  xs = ['foo', 'bar', 'apple', 'orange']

  it 'should check if item is present in an array', ->
    (_.contains 'bar', xs).should.equal true
    (_.contains 'baz', xs).should.equal false


describe 'contains.keys', ->
  kv = { foo: 1, bar: 2, apple: 3, orange: 4 }

  it 'should check if item is present in object\'s keys', ->
    (_.contains.keys 'bar', kv).should.equal true
    (_.contains.keys 'baz', kv).should.equal false


describe 'contains.values', ->
  kv = { foo: 1, bar: 2, apple: 3, orange: 4 }

  it 'should check if item is present in obejct\'s values', ->
    (_.contains.values 3, kv).should.equal true
    (_.contains.values 0, kv).should.equal false


describe 'in', -> 
  xs = ['foo', 'bar', 'apple', 'orange']
  kv = { foo: 1, bar: 2, apple: 3, orange: 4 }

  it 'should check if array contains item', ->
    (_.in xs, 'bar').should.equal true
    (_.in xs, 'baz').should.equal false


describe 'clone', ->
  original_source = {a: 1, b: {foo: 'bar', baz: [1, 2, 3]}}


  it 'should create a deep copy of an object', ->
    source = {a: 1, b: {foo: 'bar', baz: [1, 2, 3]}}
    copy = _.clone source
    source.a = "Now I'm a string!"
    source.b.foo += 'bar'
    source.b.baz.push 'Surprise!'
    # source has been changed
    source.should.not.deep.equal original_source
    # but copy remains the same
    copy.should.deep.equal original_source


# Monoids

describe 'Monoids', ->
  a = 1; b = 2; c = 3

  # TODO: test associativity of all monoids
  # TODO: test operation with identity of all monoids
  it 'should be assosiative operations', ->
    (_.add a, _.add(b, c)).should.be.equal (_.add _.add(a, b), c)

describe 'add', ->
  a = 42
  b = 9000

  it 'should be a functional equivalent for + operator', ->
    (_.add a, b).should.be.equal a + b


describe 'multiply', ->
  a = 9
  b = 6

  it 'should  be a functional equivalent for * operator', ->
    (_.multiply a, b).should.be.equal a * b


describe 'concat', ->
  
  it 'should concatenate two array into one', ->
    (_.concat [1, 2], [3, 4]).should.be.deep.equal [1, 2, 3, 4]

  it 'should concatenate an array and a non-array value into an array with that value added', ->
    (_.concat 1, [2, 3]).should.be.deep.equal [1, 2, 3]
    (_.concat [1, 2], 3).should.be.deep.equal [1, 2, 3]

  it 'should concatenate two non-array value into an array', ->
    (_.concat 1, 2).should.be.deep.equal [1, 2]

  it 'should correctly handle false values', ->
    (_.concat [1, 2, 3], [undefined]).should.be.deep.equal [1, 2, 3, undefined]
    (_.concat [1, 2, 3], null).should.be.deep.equal [1, 2, 3, null]
    (_.concat null, [1, 2, 3]).should.be.deep.equal [null, 1, 2, 3]


describe 'and', ->

  it 'should be a functional equivalent for && operator', ->
    (_.and true, true).should.be.equal true && true
    (_.and true, false).should.be.equal true && false
    (_.and false, true).should.be.equal true && false
    (_.and false, false).should.be.equal false && false


describe 'or', ->

  it 'should be a functional equivalent for || operator', ->
    (_.or true, true).should.be.equal true || true
    (_.or true, false).should.be.equal true || false
    (_.or false, true).should.be.equal false || true
    (_.or false, false).should.be.equal false || false


describe 'extend', ->
  a = {a: 1, b: 1}
  b = {b: 2, c: 2}

  it 'should combine values from two objects into one, ' +
    'replacing value if key already exists', ->
    (_.extend a, b).should.deep.equal {a: 1, b: 2, c: 2}


describe 'combine', ->
  a = {a: 1, b: 1}
  b = {b: 2, c: 2}

  it 'should combine values from two objects into one', ->
    (_.combine a, b).should.deep.equal {a: [1], b: [1, 2], c: [2]}

  it 'should not remove false values', ->
    a = {a: 1, b: undefined}
    b = {b: 2, c: undefined}
    (_.combine a, b).should.deep.equal {a: [1], b: [undefined, 2], c: [undefined]}


describe 'max', ->
  bigger = 5; smaller = 3

  it 'should return biggest of two numbers', ->
    (_.max bigger, smaller).should.equal bigger


describe 'min', ->
  bigger = 5; smaller = 3

  it 'should return biggest of two numbers', ->
    (_.min bigger, smaller).should.equal smaller


# Reducers

describe 'sum', ->
  xs = [1, 2, 3]
  result = 1 + 2 + 3

  it 'should sum an array of numbers', ->
    (_.sum xs).should.be.equal result

  it 'should result in zero if array is empty', ->
    (_.sum []).should.be.equal 0


describe 'product', ->
  xs = [1, 2, 3]
  result = 1 * 2 * 3

  it 'should return a product of array of numbers', ->
    (_.product xs).should.be.equal result

  it 'should result in 1 if array is empty', ->
    (_.product []).should.be.equal 1


describe 'flatten', ->

  it 'should flatten array of arrays', ->
    xs      = [[1], [2, 3], [4, 5, 6]]
    flat_xs = [1, 2, 3, 4, 5, 6]
    (_.flatten xs).should.deep.equal flat_xs

  it 'should flatten array of arrays and single elements', ->
    xs      = [[1], 2, 3, [4, 5, 6]]
    flat_xs = [1, 2, 3, 4, 5, 6]
    (_.flatten xs).should.deep.equal flat_xs

  it 'should leave array of non-arrays unchanged', ->
    xs = [1, 2, 3]
    (_.flatten xs).should.deep.equal xs

  it 'should return empty array if its argument is not an array or an object', ->
    (_.flatten 1).should.deep.equal []

  it 'should return empty array if empty array is given as an argument', ->
    (_.flatten []).should.deep.equal []


describe 'flatten.dict', ->
  it 'should combine array of objects into one by sequential extension', ->
    kv      = [{a: 1}, {b: 2}, {c: 3}]
    flat_kv = {a: 1, b: 2, c: 3}
    (_.flatten.dict kv).should.deep.equal flat_kv


describe 'all', ->
  xs = [1, 2, 3, 4, 5]
  evens = [2, 4, 6, 8]
  even = (x) -> x % 2 == 0

  it 'should return true, only if all values in an array matches provided predicate', ->
    (_.all even, xs).should.be.equal false
    (_.all even, evens).should.be.equal true

  it 'should return true if array is empty', ->
    (_.all even, []).should.be.equal true


describe 'any', ->
  even = (x) -> x % 2 == 0

  it 'should return true, if any value in an array matches provided predicate', ->
    (_.any even, [1, 2, 3]).should.be.equal true
    (_.any even, [2, 4, 6]).should.be.equal true
    (_.any even, [1, 3, 5]).should.be.equal false

  it 'should return false if array is empty', ->
    (_.any even, []).should.be.equal false


describe 'gather', ->
  xs = [
    {a: 1, b: 1}
    {b: 2, c: 2}
    {c: 3, d: 3}
    {a: 4, e: 4}
  ]

  it 'should sequentially combine objects in an array', ->
    (_.gather xs).should.deep.equal {a: [1, 4], b: [1, 2], c: [2, 3], d: [3], e: [4]}


describe 'sequence', ->
  xs = [
    {a: 1, b: 1}
    {b: 2, c: 2}
    {c: 3, d: 3}
    {a: 4, e: 4}
  ]
  u = null
  result =
    a: [1, u, u, 4]
    b: [1, 2, u, u]
    c: [u, 2, 3, u]
    d: [u, u, 3, u]
    e: [u, u, u, 4]

  it 'should sequentially combine objects in an array, filling non-existent values', ->
    (_.sequence xs).should.deep.equal result


describe 'biggest', ->
  biggest = 45
  smallest = 3
  xs = [smallest, biggest, 23]

  it 'should return the biggest number in an array', ->
    (_.biggest xs).should.equal biggest

  # XXX: should I fix that behaviour?
  it 'should return minus Infinity if given array is empty', ->
    (_.biggest []).should.equal (-Infinity)


describe 'smallest', ->
  biggest = 45
  smallest = 3
  xs = [smallest, biggest, 23]

  it 'should return the smallest number in an array', ->
    (_.smallest xs).should.equal smallest

  # XXX: should I fix that behaviour?
  it 'should return Infinity if given array is empty', ->
    (_.smallest []).should.equal Infinity


# Function Composition

describe 'pipe', ->
  f = (x) -> x + 1
  g = (x) -> x * x
  x = 5

  it 'should combine multiple functions into one function that performs them sequentially', ->
    ((_.pipe f, g)(x)).should.be.equal (g (f x))

describe 'compose', ->
  f = (x) -> x + 1
  g = (x) -> x * x
  x = 5

  it 'should be similar to pipe but take functions in reverse order', ->
    ((_.compose g, f)(x)).should.be.equal (g (f x))
    ((_.compose g, f)(x)).should.be.equal ((_.pipe f, g)(x))


# Other Stuff

describe 'group_by', ->
  xs = [1, 2, 3, 4, 5, 6]
  even = (x) -> x % 2 == 0

  it 'should group items based on given function result', ->
    (_.group_by even, xs).should.be.deep.equal {true: [2, 4, 6], false: [1, 3, 5]}
    (_.group_by _.id, xs).should.be.deep.equal {1: [1], 2: [2], 3: [3], 4: [4], 5: [5], 6: [6]}


describe 'average', ->
  xs  = [1, 2, 3, 4, 5]
  avg = (1 + 2 + 3 + 4 + 5) / 5

  it 'should return average of an array of numbers', ->
    (_.average xs).should.be.equal avg

  it 'should return zero if array is empty', ->
    (_.average []).should.be.equal 0


# Array accessors

describe 'head', ->
  first = 1
  xs = [first, 2, 3, 4, 5]

  it 'should return first element of the array', ->
    _.head(xs).should.equal first

  it 'should return undefined if array is empty', ->
    expect(_.head([])).equal undefined


describe 'last', ->
  last = 5
  xs = [1, 2, 3, 4, last]

  it 'should return last element of the array', ->
    _.last(xs).should.equal last

  it 'should return undefined if array is empty', ->
    expect(_.last([])).equal undefined


describe 'tail', ->
  xs = [1, 2, 3]

  it 'should return all element of the array but first', ->
    _.tail(xs).should.deep.equal [2, 3]

  it 'should return empty array if array is empty', ->
    _.tail([]).should.deep.equal []


describe 'init', ->
  xs = [1, 2, 3]

  it 'should return all element of the array but last', ->
    _.init(xs).should.deep.equal [1, 2]

  it 'should return empty array if array is empty', ->
    _.init([]).should.deep.equal []


describe 'take', ->
  xs = [-2, -1, 0, 1, 2]

  it 'should take first n elements of array', ->
    _.take(3, xs).should.deep.equal [-2, -1, 0]

  it 'should return a whole list if n is bigger then it\'s length', ->
    _.take(15, xs).should.deep.equal xs


describe 'take.while', ->
  xs = [-2, -1, 0, 1, 2]

  it 'should take elements of array as long as predicate returns true', ->
    _.take.while((_.lt 0), xs).should.deep.equal [-2, -1]
    _.take.while((_.lt -5), xs).should.deep.equal []


describe 'drop', ->
  xs = [-2, -1, 0, 1, 2]

  it 'should drop first n elements of array', ->
    _.drop(3, xs).should.deep.equal [1, 2]

  it 'should return an empty list if n is bigger then it\'s length', ->
    _.drop(15, xs).should.deep.equal []


describe 'drop.while', ->
  xs = [-2, -1, 0, 1, 2]

  it 'should drop elements of array as long as predicate returns true', ->
    _.drop.while((_.lt 0), xs).should.deep.equal [0, 1, 2]
    _.drop.while((_.lt -5), xs).should.deep.equal xs


describe 'relate', ->
  a = {a: 1, b: 2, c: 3}
  b = {b: 4, c: 5, d: 6}
  f = (a, b) -> a * b

  it 'should sequence two objects and apply binary function to every element', ->
    (_.relate f, a, b).should.be.deep.equal {a: 0, b: 8, c: 15, d: 0}

  it 'should be autocurried only for first argument', ->
    ((_.relate f)(a, b)).should.be.deep.equal {a: 0, b: 8, c: 15, d: 0}

