#!/usr/bin/env coffee

print = console.log.bind console, ">>>:"
error = console.log.bind console, "ERROR:"
warn  = console.log.bind console, "WARNING:"

{def, concat} = require '../lambda'
{lambda_class, call} = require '../class'


monoid = lambda_class 'mappend', 'mempty'


mappend = def (a, b) -> a.__lambda__.mappend a, b
mempty  = (o) -> o.__lambda__.mempty


# ====Instances====
monoid Array,
  mappend: concat
  mempty: []

module.exports = exports =
  monoid: monoid
  mempty: mempty
  mappend: mappend
