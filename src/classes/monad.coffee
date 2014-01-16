#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'
{lambda_class, call} = require '../class'


monad = lambda_class 'bind', 'mreturn'


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
