#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'
{lambda_class, call} = require '../class'


applicative = lambda_class 'fapply', 'pure'


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
  applicative: applicative
  fapply: fapply
  pure: pure
