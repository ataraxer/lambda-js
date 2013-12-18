#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

{Just, Nothing} = require './types/maybe'
{print} = require './print'


detectNaN = (x) ->
	x.constructor? and x.constructor.name is 'Number' and x != x


wrap = (x) ->
	isNully = x == undefined or x == null or detectNaN x
	if isNully then Nothing else Just x


module.exports = exports =
	wrap: wrap
