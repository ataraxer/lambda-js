#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'
{lambda_class} = require '../class'


functor = lambda_class 'fmap'


fmap = def (f, o) ->
  o.__lambda__.fmap f, o


# ====Instances====
functor Array,
  fmap: _.map


module.exports = exports =
  fmap: fmap
  functor: functor
