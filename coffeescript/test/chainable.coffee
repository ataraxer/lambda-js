# Chainable interface to lambda test
assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

_ = require '../src/lambda'
{chain} = require '../src/chainable'


# ==== Tests ====

describe 'chain', ->
  square = (x) -> x * x
  gt = (y) -> (x) -> x > y

  result_a = (chain [1, 2, 3]).map(square).filter(gt 5)
  result_b = (chain {a: 1, b: 2, c: 3})
    .map.values(square)
    .omit.keys(_.in ['b'])
    .values()
    .pipe(_.sum)

  it 'should return chainable object for simple function composition', ->
    result_a.data.should.be.deep.equal [9]
    result_b.data.should.equal 10
