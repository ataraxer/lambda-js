#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'

prototype = (o) ->
	o.prototype

call = (f, args...) -> switch f.constructor.name
		when 'Function' then f args...
		else f

applicative = (o, d) ->
	proto = (prototype o)
	proto.__lambda__ =
		(_.extend proto.__lambda__ or {}) d

fapply = def (fs, o) ->
	o.__lambda__.fapply (call fs, o), o

pure = (x) -> (o) -> o.__lambda__.pure x


# ====Instances====
applicative Array,
	fapply: (fs, o) ->
		each = (f) -> _.map f, o
		_.flat_map each, fs
	pure: (x) -> [x]


module.exports = exports =
	fapply: fapply
	applicative: applicative
	pure: pure
