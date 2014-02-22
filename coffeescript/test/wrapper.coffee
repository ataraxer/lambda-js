# This file provides tests for `Wrapper` module.

# Mocha and Chai initialization

assert = require 'assert'

chai = require 'chai'
chai.should()

expect = chai.expect

# Modules initialization

_ = require '../src/lambda'
{wrap} = require '../src/wrapper'
{Just, Nothing} = require '../src/types/maybe'

# Tests

describe 'wrap', ->

  it 'should return Nothing for undefined', ->
    (wrap undefined).should.be.deep.equal Nothing

  it 'should return Nothing for null', ->
    (wrap null).should.be.deep.equal Nothing

  it 'should return Nothing for NaN', ->
    (wrap NaN).should.be.deep.equal Nothing

  it 'should return Just a value for everything else', ->
    xs = [42, 0, -42, -34.34, 'string', '', [], [0], [1, 2, 3], {}, {key: 'value'}]
    for x in xs
      (wrap x).should.be.deep.equal Just x

