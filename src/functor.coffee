#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = require './lambda'

functor = (o, f) ->
	o.constructor.prototype.fmap = f

fmap = (f) -> (o) ->
	o.fmap.call o, f


module.exports = exports =
	fmap: fmap
	functor: functor
