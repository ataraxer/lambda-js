#!/usr/bin/env coffee

{functor, fmap} = require './functor'
{applicative, fapply} = require './applicative'
{monad} = require './monad'


class Maybe
	type: -> 'Maybe'

class Just extends Maybe
	constructor: (@value) ->
	cons: -> 'Just'
	show: ->
		console.log 'Just ' + @value

class Nothing extends Maybe
	cons: -> 'Nothing'
	show: ->
		console.log 'Nothing'


just    = (v) -> new Just v
nothing = new Nothing()

print = (xs...) ->
	for x in xs
		if x.show?
			console.log x.show()
		else
			console.log x


functor Maybe, (f, o) -> switch do o.cons
	when 'Just'    then just (f o.value)
	when 'Nothing' then nothing


add = (a) -> (b) -> a + b


applicative Maybe,
	fapply: (f, o) ->
		if (do f.cons) is 'Nothing'
			nothing
		else (fmap f.value) o
	pure: just


module.exports = exports =
	just: just
	nothing: nothing
