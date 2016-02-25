require('gulp-lazyload')
  gulp:       'gulp'
  connect:    'gulp-connect'
  concat:     'gulp-concat'
  coffee:     'gulp-coffee'
  preprocess: 'gulp-preprocess'
  iife:       'gulp-iife'
  uglify:     'gulp-uglify'
  rename:     'gulp-rename'
  del:        'del'
  plumber:    'gulp-plumber'
  replace:    'gulp-replace'

gulp.task 'default', ['build', 'watch'], ->

dependencies = [
  {require: 'coffee-concerns'}
  {require: 'callbacks',            global: 'Callbacks'}
  {require: 'publisher-subscriber', global: 'PublisherSubscriber'}
  {require: 'construct-with',       global: 'ConstructWith'}
  {require: 'property-accessors',   global: 'PropertyAccessors'}
]

gulp.task 'build', ->
  gulp.src('source/core-object.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe iife {global: 'CoreObject', dependencies}
  .pipe concat('core-object.coffee')
  .pipe gulp.dest('build')
  .pipe coffee()
  .pipe concat('core-object.js')
  .pipe gulp.dest('build')

gulp.task 'build-min', ['build'], ->
  gulp.src('build/core-object.js')
  .pipe uglify()
  .pipe rename('core-object.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
