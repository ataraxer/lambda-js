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


functor Writer,
  fmap: (f, {x, v}) ->
    Writer (f x), v


applicative Writer,
  fapply: ({f, v}, w) ->
    fmap f, w
  pure: (x) -> Writer x, []


monad Writer,
  bind: (f, {x, v}) ->
    {y, v_} = f x
    Writer y, v.append v_
  mreturn: (x) -> Writer x, []


module.exports = exports =
  Writer: Writer

