#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'
{lambda_class, call} = require '../class'


monad = lambda_class 'bind', 'mreturn'


bind = def (f, o) ->
  if o.__lambda__ and o.__lambda__.mreturn_wrap
    o = o f.__lambda__.returns
  o.__lambda__.bind f, o


mreturn = (x) ->
  f = (o) -> o.prototype.__lambda__.mreturn x
  f.__lambda__ = (_.extend mreturn_wrap: true) (f.__lambda__ or {})
  return f

returns = (o) -> (f) ->
  f.__lambda__ = (_.extend returns: o) (f.__lambda__ or {})
  return f


# ====Instances====
monad Array,
  bind: (f, o) ->
    (_.map.flat f) o
  mreturn: (x) -> [x]


module.exports = exports =
  monad: monad
  bind: bind
  mreturn: mreturn
  returns: returns
