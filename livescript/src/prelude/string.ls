#!/usr/bin/env lsc

{head} = require './lambda'


join = (v, xs) -->
  xs?.join? v

split = (s, str) -->
  str?.split? s


uppercase = -> it?.toUpperCase!

lowercase = -> it?.toLowerCase!

capitalize = ->
  (uppercase (head it)) + (it?.slice? 1)


substitute = (a, b, str) -->
  str?.replace a, b

sub = substitute


module.exports = exports = {
  join, split, uppercase, lowercase, capitalize, substitute, sub
}

