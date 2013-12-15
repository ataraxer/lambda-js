This file provides tests for `Functor` module.

Mocha and Chai initialization

	assert = require 'assert'

	chai = require 'chai'
	chai.should()

	expect = chai.expect

Module initialization

	_ = require '../src/lambda'
	{fmap} = require '../src/classes/functor'

Tests
-------

	describe 'Functor', ->
		xs = [1, 2, 3]

		it 'should be an abstract container that can be mapped over', ->
			((fmap (_.add 2)) xs).should.be.deep.equal [3, 4, 5]
