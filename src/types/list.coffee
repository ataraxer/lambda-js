#!/usr/bin/env coffee

_ = {def} = require '../lambda'
{print, show} = require '../print'
{Just, Nothing} = require './maybe'

{functor}     = require '../classes/functor'
{applicative} = require '../classes/applicative'
{monad}       = require '../classes/monad'


type = (x) ->
	if x.type?
		do x.type
	else switch x.constructor.name
		when 'Number' then (if isNaN x then 'NaN' else x.constructor.name)
		else x.constructor.name


class _List
	type: -> 'List'
	eq: (m) -> do @cons == do m.cons and @value == m.value
	constructor: (@value) ->
	cons: -> 'List'
	show: -> '[' + (_.join ', ', (_.map show, @value)) + ']'


List = (a) ->
	if (_.length _.uniq (_.map type) a) == 1
		new _List a
	else
		console.log "TypeError"
		Nothing


functor _List,
	fmap: def (f, xs) ->
		List (_.map f) xs.value


applicative _List,
	fapply: def (fs, o) ->
		each = (f) -> _.map f, o.value
		List _.flat_map each, fs.value
	pure: (x) -> List x


monad _List,
	bind: def (f, o) ->
		List (_.flat_map f) o.value
	mreturn: (x) -> List x


module.exports = exports =
	List: List
