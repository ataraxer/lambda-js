This file provides tests for `Monad` module.

Mocha and Chai initialization

	assert = require 'assert'

	chai = require 'chai'
	chai.should()

	expect = chai.expect

Modules initialization

	_ = require '../src/lambda'
	{bind} = require '../src/monad'

Tests
-------

	describe 'Monad', ->
		repeat = (n) -> (x) -> x for i in _.range n
		xs = [1, 2, 3]

		it 'should be able to call functions on a value with a context while preserving context', ->
			((bind repeat 3) xs).should.be.deep.equal [1, 1, 1, 2, 2, 2, 3, 3, 3]
