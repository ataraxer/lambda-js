#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require './lambda'

class LambdaType

prototype = (o) -> o.prototype

call = (f, args...) ->
	switch f.constructor.name
		when 'Function' then f args...
		else f

instance = (req) -> (o, d) ->
	proto = prototype o
	proto.__lambda__ =
		(_.extend proto.__lambda__ or {}) d

bind = def (f, o) ->
	o.__lambda__.bind f, o

mreturn = (x) -> (o) -> o.__lambda__.mreturn x


modules.exports = exports =
	print: print = (xs...) ->
		for x in xs
			if x.show?
				print x.show()
			else
				print x
