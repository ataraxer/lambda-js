# This file provides tests for `Either` type.

# Mocha and Chai initialization

assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

# Modules initialization

_ = require '../src/lambda'
{Right, Left} = require '../src/types/either'
{fmap}   = require '../src/classes/functor'
{fapply} = require '../src/classes/applicative'
{bind}   = require '../src/classes/monad'

# Tests

describe 'Either', ->

  it 'should be an instance of functor', ->
    ((fmap _.add 3) Right 5).should.be.deep.equal Right 8
    ((fmap _.add 3) Left "Error!").should.be.deep.equal Left "Error!"

  it 'should be an instance of applicative functor', ->
    ((fapply Right _.add 3) Right 5).should.be.deep.equal Right 8
    ((fapply Right _.add 3) Left "Error!").should.be.deep.equal Left "Error!"
    ((fapply Left "Error!") Right 5).should.be.deep.equal Left "Error!"
    ((fapply Left "Error 1!") Left "Error 2!").should.be.deep.equal Left "Error 1!"

  it 'should be an instance of monad', ->
    sqrt = (x) -> if x >= 0 then Right Math.sqrt x else Left "Error!"

    ((bind sqrt) Right 25).should.be.deep.equal Right 5
    ((bind sqrt) Right -25).should.be.deep.equal Left "Error!"
    ((bind sqrt) Left "Error!").should.be.deep.equal Left "Error!"
