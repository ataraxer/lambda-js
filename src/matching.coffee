#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"


{Nothing, Just} = require './types/maybe'

state = (f) -> (args...) ->
	f.apply {}, args

pattern = (p, f) -> [p, f]

match = (x, ps...) ->
	for [p, f] in ps when x.eq? and x.eq p
		return f x

foo = state (x) ->
	match x,
		pattern (Just 5), -> print "it's just 5"
		pattern Nothing,  -> print "it's nothing"

foo Just 5
foo Nothing


module.exports = exports = foo
