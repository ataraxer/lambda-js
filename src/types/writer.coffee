#!/usr/bin/env coffee

{functor, fmap} = require '../classes/functor'
{applicative}   = require '../classes/applicative'
{monad}         = require '../classes/monad'


class WriterClass
  type: -> 'Writer'
  eq: (m) ->
    do @cons == do m.cons and @a == m.a and @w == m.w
  constructor: (@a, @w) ->
  cons: -> 'Writer'
  show: -> "Writer #{@a}, #{@w}"


Writer = (a, w) -> new WriterClass a, w


functor WriterClass,
  fmap: (f, {a, w}) ->
    Writer (f a), w


applicative WriterClass,
  fapply: ({a, w: v}, w) ->
    fmap a, w
  pure: (x) -> Writer x, []


monad WriterClass,
  bind: (f, {a, w}) ->
    {a: y, w: v_} = f a
    Writer y, w.concat v_
  mreturn: (x) -> Writer x, []


module.exports = exports =
  Writer: Writer

