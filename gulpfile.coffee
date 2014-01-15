#!/usr/bin/env coffee

# ==== GULP ====

gulp  = require 'gulp'
gutil = require 'gulp-util'


# ==== PLUGINS ====

lint   = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
mocha  = require 'gulp-mocha'
clean  = require 'gulp-clean'


# ==== CONSTANTS ====

SOURCE_DIR   = 'src/'
SOURCE_FILES = [SOURCE_DIR + '*.coffee']

BUILD_DIR   = 'build/'
BUILD_FILES = [BUILD_DIR + '*.js']

TEST_DIR   = 'test/'
TEST_FILES = [TEST_DIR + '*.coffee', TEST_DIR + '*.litcoffee']


# ==== TASKS ====

gulp.task 'default', ->
  gulp.run('build')


gulp.task 'build', ->
  gulp.run('test')
  gulp.src(SOURCE_FILES)
    .pipe(do lint)
    .pipe(do coffee)
    .pipe(gulp.dest BUILD_DIR)


gulp.task 'clean', ->
  gulp.src(BUILD_DIR, read: false)
    .pipe(do clean)


gulp.task 'test', ->
  gulp.src(TEST_FILES, read: false)
    .pipe(do mocha)

