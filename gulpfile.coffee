gulp    = require 'gulp'
concat  = require 'gulp-concat'
coffee  = require 'gulp-coffee'
umd     = require 'gulp-umd-wrap'
plumber = require 'gulp-plumber'
fs      = require 'fs'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    {require: 'coffee-concerns'}
    {require: 'initializable',           global: 'Initializable'}
    {require: 'finalizable',             global: 'Finalizable'}
    {require: 'publisher-subscriber',    global: 'PublisherSubscriber'}
    {require: 'pub-sub-callback-api',    global: 'Callbacks'}
    {require: 'property-accessors-node', global: 'PropertyAccessors'}
  ]
  header = fs.readFileSync('source/__license__.coffee')
  
  gulp.src('source/core-object.coffee')
    .pipe plumber()
    .pipe umd({global: 'CoreObject', dependencies, header})
    .pipe concat('core-object.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('core-object.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
