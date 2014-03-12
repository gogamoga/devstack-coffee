Gogamatic Devstack Gulpfile
===========================

Configuration
-------------

    build = './build'
    dist = './dist'
    src = './src'
    test = './test'

    projectCoffeeSource = [ "#{src}/**/*.+(litcoffee|coffee)", "!#{src}/test" ]
    testCoffeeSource = [ "#{src}/test/**/*.+(litcoffee|coffee)" ]

    projectBuildDest = build
    testBuildDest = test

    projectDistDest = dist

Preparations
------------

    gulp = require 'gulp'

    runSequence = require 'run-sequence'
    util = require 'gulp-util'    
    rimraf = require 'gulp-rimraf'
    mocha = require 'gulp-mocha'
    coffee = require 'gulp-coffee'
    coffeelint = require 'gulp-coffeelint'
    uglify = require 'gulp-uglify'

Mini tasks
----------

    gulp.task 'clean-project', ->
      gulp
        .src [ 
          "#{projectBuildDest}/*", "#{projectDistDest}" 
          projectBuildDest, projectDistDest ], read: false
        .pipe rimraf force: true

---

    gulp.task 'clean-test', ->
      gulp
        .src [ "#{testBuildDest}/*", testBuildDest ], read: false
        .pipe rimraf force: true

---

    gulp.task 'lint-project-coffee', ->    
      gulp
        .src projectCoffeeSource
        .pipe coffeelint()
        .pipe coffeelint.reporter()

---
    
    gulp.task 'lint-test-coffee', ->
      gulp
        .src testCoffeeSource
        .pipe coffeelint()
        .pipe coffeelint.reporter()

---

    gulp.task 'compile-project-coffee', ['lint-project-coffee'], ->    
      gulp
        .src projectCoffeeSource
        .pipe coffee(bare: true).on 'error', util.log
        .pipe gulp.dest projectBuildDest

---

    gulp.task 'compile-test-coffee', ['lint-test-coffee'], ->
      gulp
        .src testCoffeeSource
        .pipe coffee(bare: true).on 'error', util.log
        .pipe gulp.dest testBuildDest

---
  
    gulp.task 'build-project-coffee', ->
      gulp
        .src "#{projectBuildDest}/**/*.js"
        .pipe uglify()
        .pipe gulp.dest projectDistDest

---

    gulp.task 'test', ->
        gulp
          .src ["#{test}/**/*.js"], read: false
          .pipe mocha 
                  reporter: 'spec'
                  globals: 
                    should: require 'should'

Umbrella tasks
--------------

    gulp.task 'clean', (cb) ->      
      runSequence "clean-project", "clean-test", cb

---      

    gulp.task 'lint-coffee', (cb) ->
      runSequence 'lint-project-coffee', 'lint-test-coffee', cb

---

    gulp.task 'lint', (cb) ->
      runSequence 'lint-coffee', cb

---

    gulp.task 'compile-coffee', (cb) ->
      runSequence 'compile-project-coffee', 'compile-test-coffee', cb

---
    
    gulp.task 'compile', (cb) ->
      runSequence 'compile-coffee', cb

---

    gulp.task 'build', (cb) ->
      runSequence 'compile', 'build-project-coffee', cb


Default task
------------

    gulp.task 'default', (cb) ->
      runSequence 'clean', 'build', 'test', cb