#!/usr/bin/env coffee

_ = require './lambda'


print = console.log.bind console, '>>>'

chain = (data) -> new Chainable data

class Chainable
  constructor: (@data) ->
    @map = (f) => chain (_.map f, @data)
    @map.keys = (f) => chain (_.map.keys f, @data)
    @map.values = (f) => chain (_.map.values f, @data)

  filter: (f) -> chain (_.filter f, @data)

  keys: -> chain (_.keys @data)
  values: -> chain (_.values @data)


module.exports = exports = Chainable
