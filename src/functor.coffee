#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require './lambda'

prototype = (o) ->
	o.prototype

functor = (o, f) ->
	proto = (prototype o)
	proto.__lambda__ =
		(_.extend proto.__lambda__ or {})
			fmap: f

fmap = def (f, o) ->
	o.__lambda__.fmap f, o


# ====Instances====
functor Array, _.map



module.exports = exports =
	fmap: fmap
	functor: functor
