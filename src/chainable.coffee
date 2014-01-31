#!/usr/bin/env coffee

_ = require './lambda'


chain = (data) -> new Chainable data


class Chainable
  constructor: (@data) ->
    @map = (f) => chain (_.map f, @data)
    @map.keys = (f) => chain (_.map.keys f, @data)
    @map.values = (f) => chain (_.map.values f, @data)
    @map.items = (f) => chain (_.map.items f, @data)
    @map.flat = (f) => chain (_.map.items f, @data)

    @filter = (f) => chain (_.filter f, @data)
    @filter.keys = (f) => chain (_.filter.keys f, @data)
    @filter.values = (f) => chain (_.filter.values f, @data)

    @omit = (f) => chain (_.omit f, @data)
    @omit.keys = (f) => chain (_.omit.keys f, @data)
    @omit.values = (f) => chain (_.omit.values f, @data)

    @find = (f) => chain (_.find f, @data)
    @find.keys = (f) => chain (_.find.keys f, @data)
    @find.values = (f) => chain (_.find.values f, @data)
    @find.items = (f) => chain (_.find.items f, @data)

    sort = => chain (_.sort @data)
    sort.by = (f) => chain (_.sort.by @data)

  pipe: (f) -> chain (f @data)

  keys: -> chain (_.keys @data)
  values: -> chain (_.values @data)
  items: -> chain (_.items @data)

  gather: -> chain (_.gather @data)
  sequence: -> chain (_.sequence @data)

  group_by: (f) -> chain (_.group_by f, @data)

  uniq: -> chain (_.uniq @data)
  dict: -> chain (_.dict @data)


module.exports = exports =
  Chainable: Chainable
  chain: chain
