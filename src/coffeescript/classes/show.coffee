#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require '../lambda'

prototype = (o) ->
  o.prototype

functor = (o, d) ->
  proto = (prototype o)
  proto.__lambda__ =
    (_.extend proto.__lambda__ or {}) d

show = def (f, o) ->
  o.__lambda__.show f, o


# ====Instances====
functor Array,
  show: _.map


module.exports = exports =
  show: show
