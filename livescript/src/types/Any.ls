#!/usr/bin/env lsc


class Any
  -> Object.freeze(this)

  getClass: -> @constructor.name

  isInstanceOf: -> ...
  asInstanceOf: -> ...

  asString: -> 'Any'

  eq: (other) ->
    @getClass is other.getClass

  ne: (other) -> not @eq(other)

  hashCode: -> ...


module.exports = exports = Any

