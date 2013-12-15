This file provides tests for `Applicative` module.

Mocha and Chai initialization

	assert = require 'assert'

	chai = require 'chai'
	chai.should()

	expect = chai.expect

Module initialization

	_ = require '../src/lambda'
	{fapply} = require '../src/classes/applicative'

Tests
-------

	describe 'Applicative', ->
		fs = [(_.add 1), (_.multiply 2)]
		xs = [5, 6, 7]

		it 'should be an abstract container that can be mapped over with another container', ->
			((fapply fs) xs).should.be.deep.equal [6, 7, 8, 10, 12, 14]
