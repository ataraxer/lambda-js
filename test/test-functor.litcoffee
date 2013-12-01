This file provides tests for `Functor` module.

Importing `assert` from `mocha` node module.

	assert = require 'assert'

	chai = require 'chai'
	chai.should()

	expect = chai.expect

Importing functor and fmap from `Functor` module

	_ = require '../src/lambda'
	{fmap: fmap, functor: functor} = require '../src/functor'

Tests
-------

	describe 'Functor', ->
		xs = [1, 2, 3]
		# define built in map as fmap function for array
		functor [], [].map


		it 'should be an abstract container that can be mapped over', ->
			((fmap (_.add 2)) xs).should.be.deep.equal [3, 4, 5]

