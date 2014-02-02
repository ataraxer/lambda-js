# This file provides tests for `Writer` type.

# Mocha and Chai initialization

assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

# Modules initialization

_ = require '../src/lambda'
{Writer} = require '../src/types/writer'
{fmap}   = require '../src/classes/functor'
{fapply} = require '../src/classes/applicative'
{bind}   = require '../src/classes/monad'

# Tests

describe 'Writer', ->
  w = Writer 5, []

  it 'should be an instance of functor', ->
    ((fmap _.add 3) w).should.be.deep.equal Writer 8, []

  it 'should be an instance of applicative functor', ->
    (fapply (Writer (_.add 3), []), w).should.be.deep.equal Writer 8, []

  it 'should be an instance of monad', ->
    square = (x) -> Writer x*x, ["squared #{x}"]

    ((bind square) Writer 5, ['done nothing']).should.be.deep.equal Writer 25, ['done nothing', 'squared 5']
