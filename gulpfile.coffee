#!/usr/bin/env coffee

# ==== GULP ====

gulp = require 'gulp'
gutil = require 'gulp-util'


# ==== PLUGINS ====

coffee = require 'gulp-coffee'
lint = require 'gulp-coffeelint'
mocha = require 'gulp-mocha'
clean = require 'gulp-clean'


# ==== TASKS ====

gulp.task 'default', ->
  gulp.run('build')


gulp.task 'build', ->
  gulp.run('test')
  gulp.src(['src/*.coffee'])
    .pipe(lint())
    .pipe(coffee())
    .pipe(gulp.dest 'build')


gulp.task 'clean', ->
  gulp.src(['build/*'])
    .pipe(clean())


gulp.task 'test', ->
  gulp.src(['test/*.coffee'])
    .pipe(coffee())
    .pipe(mocha)
