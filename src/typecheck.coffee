#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

types = (signature...) -> (f) ->
	(args...) ->
		for type, i in signature
			if not (args[i]? and type args[i])
				return
		f args...


typec = (signature) -> (f) ->
	(args) ->
		for name, type of signature
			if not (args[name]? and type args[name])
				return
		f args


sub = (t) -> (f) -> (x) ->
	(t x) and (f x)


Num = Float = (x) ->
	x.constructor.name is 'Number' \
		and (not isNaN x)


Int = (sub Num) (x) ->
	x % 1 is 0


# automated
foo = (types Int, Int) (x, y) ->
	x + y


bar = (typec x: Num, y: Num) (args) ->
	args.x + args.y


# manual
baz = (x, y) ->
	if Num x and Num y
		x + y


module.exports = exports = foo
