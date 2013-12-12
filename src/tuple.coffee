#!/usr/bin/env coffee

_ = require './lambda'
{print, show} = require './print'


class _Tuple
	type: -> 'Tuple'
	eq: (m) -> do @cons == do m.cons and @value == m.value
	constructor: (@value) ->
	cons: -> 'Tuple'
	show: -> '(' + (_.join ', ', (_.map show, @value)) + ')'


Tuple = (a...) -> new _Tuple a

print (Tuple 1, 2, "let's put in to test")


module.exports = exports =
	Tuple: Tuple
