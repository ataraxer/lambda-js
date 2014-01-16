#!/usr/bin/env coffee

_ = require './lambda'


repr = (x) -> if x.show? then do x.show else x


show = (x) ->
  switch x.constructor.name
    when 'String' then '"' + x + '"'
    else repr x


module.exports = exports =
  print: (xs...) ->
    console.log (_.join ' ') (_.map show) xs
  show: show
