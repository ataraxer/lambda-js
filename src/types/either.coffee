#!/usr/bin/env coffee

{functor, fmap} = require '../classes/functor'
{applicative}   = require '../classes/applicative'
{monad}         = require '../classes/monad'


class Either
	type: -> 'Either'
	eq: (m) -> do @cons == do m.cons and @value == m.value


class EitherRight extends Either
	constructor: (@value) ->
	cons: -> 'Right'
	show: -> 'Right ' + @value


class EitherLeft extends Either
	constructor: (@value) ->
	cons: -> 'Left'
	show: -> 'Left ' + @value


Right = (v) -> new EitherRight v
Left  = (v) -> new EitherLeft  v


functor Either,
	fmap: (f, o) -> switch do o.cons
		when 'Right' then Right (f o.value)
		when 'Left'  then o


applicative Either,
	fapply: (f, o) -> switch do f.cons
		when 'Left' then f
		else (fmap f.value) o
	pure: Right


monad Either,
	bind: (f, o) -> switch do o.cons
		when 'Right' then f o.value
		when 'Left'  then o
	mreturn: Right


module.exports = exports =
	Right: Right
	Left: Left
