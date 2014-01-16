#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

_ = {def: def} = require './lambda'


prototype = (o) ->
  o.prototype


lambda_class = (required...) ->
  meets_requirements = (d) ->
    not (_.difference required, _.keys d)

  (o, d) ->
    if meets_requirements d
      error "wrong instance declaration"
    proto = prototype o
    proto.__lambda__ =
      (_.extend proto.__lambda__ or {}) d


module.exports = exports =
  lambda_class: lambda_class
  call: (f, args...) -> switch f.constructor.name
    when 'Function' then f args...
    else f

