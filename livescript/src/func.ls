#!/usr/bin/env lsc


_ = {}

_.pipe    = (...fs) -> fs.reduce (>>)
_.compose = (...fs) -> fs.reduce (<<)

_.not = (f) -> (...args) -> not (f ...args)

_.apply = (f, xs) --> f.apply null, xs


module.exports = exports = _

