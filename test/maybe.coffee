# This file provides tests for `Maybe` type.

# Mocha and Chai initialization

assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

# Modules initialization

_ = require '../src/lambda'
{Just, Nothing} = require '../src/types/maybe'
{fmap}   = require '../src/classes/functor'
{fapply} = require '../src/classes/applicative'
{bind}   = require '../src/classes/monad'

# Tests

describe 'Maybe', ->

  it 'should be an instance of functor', ->
    ((fmap _.add 3) Just 5).should.be.deep.equal Just 8
    ((fmap _.add 3) Nothing).should.be.deep.equal Nothing

  it 'should be an instance of applicative functor', ->
    ((fapply Just _.add 3) Just 5).should.be.deep.equal Just 8
    ((fapply Just _.add 3) Nothing).should.be.deep.equal Nothing
    ((fapply Nothing) Just 5).should.be.deep.equal Nothing
    ((fapply Nothing) Nothing).should.be.deep.equal Nothing

  it 'should be an instance of monad', ->
    sqrt = (x) -> if x >= 0 then Just Math.sqrt x else Nothing

    ((bind sqrt) Just 25).should.be.deep.equal Just 5
    ((bind sqrt) Just -25).should.be.deep.equal Nothing
    ((bind sqrt) Nothing).should.be.deep.equal Nothing
