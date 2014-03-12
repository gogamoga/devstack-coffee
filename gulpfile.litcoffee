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

Out of the box tasks
--------------------

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

    gulp.task 'clean', ["clean-project", "clean-test"], ->      

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

    gulp.task 'lint-coffee', ['lint-project-coffee', 'lint-test-coffee' ], ->

---

    gulp.task 'lint', ['lint-coffee'], ->

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
  
    gulp.task 'compile-coffee',      
              ['compile-project-coffee', 'compile-test-coffee'], -> 

---
    
    gulp.task 'compile', ['compile-coffee'], ->

---
  
    gulp.task 'build-project-coffee', [ 'compile-project-coffee'], ->
      gulp
        .src projectBuildDest
        .pipe uglify()
        .pipe gulp.dest projectDistDest

---

    gulp.task 'build', ['compile', 'build-project-coffee'], ->      

---

    gulp.task 'test', ->
        gulp
          .src ["#{test}/**/*.js"], read: false
          .pipe mocha 
                  reporter: 'spec'
                  globals: 
                    should: require 'should'

---

    gulp.task 'default', ["clean"], (cb) ->
      runSequence 'build', cb