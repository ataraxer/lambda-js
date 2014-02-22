#!/usr/bin/env coffee

{functor, fmap} = require '../classes/functor'
{applicative}   = require '../classes/applicative'
{monad}         = require '../classes/monad'


class Maybe
  type: -> 'Maybe'
  eq: (m) -> do @cons == do m.cons and @value == m.value


class MaybeJust extends Maybe
  constructor: (@value) ->
  cons: -> 'Just'
  show: -> 'Just ' + @value


class MaybeNothing extends Maybe
  cons: -> 'Nothing'
  show: -> 'Nothing'


Just    = (v) -> new MaybeJust v
Nothing = new MaybeNothing()


functor Maybe,
  fmap: (f, o) -> switch do o.cons
    when 'Just'    then Just (f o.value)
    when 'Nothing' then Nothing


applicative Maybe,
  fapply: (f, o) -> switch do f.cons
    when 'Nothing' then Nothing
    else (fmap f.value) o
  pure: Just


monad Maybe,
  bind: (f, o) -> switch do o.cons
    when 'Just'    then f o.value
    when 'Nothing' then Nothing
  mreturn: Just


module.exports = exports =
  Just: Just
  Nothing: Nothing
