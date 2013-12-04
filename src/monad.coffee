#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require './lambda'

prototype = (o) ->
	o.prototype

call = (f, args...) ->
	if f.constructor.name is 'Function'
		f args...
	else
		f

monad = (o, d) ->
	proto = (prototype o)
	proto.__lambda__ =
		(_.extend proto.__lambda__ or {}) d

bind = def (f, o) ->
	o.__lambda__.bind f, o

mreturn = (x) -> (o) -> o.__lambda__.mreturn x


# ====Instances====
monad Array,
	bind: (f, o) ->
		(_.flat_map f) o
	mreturn: (x) -> [x]


module.exports = exports =
	monad: monad
	bind: bind
	mreturn: mreturn
