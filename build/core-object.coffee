###!
# core-object 1.1.0 | https://github.com/yivo/core-object | MIT License
###

((factory) ->

  __root__ = 
    # The root object for Browser or Web Worker
    if typeof self is 'object' and self isnt null and self.self is self
      self

    # The root object for Server-side JavaScript Runtime
    else if typeof global is 'object' and global isnt null and global.global is global
      global

    else
      Function('return this')()

  # Asynchronous Module Definition (AMD)
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    define ['initializable', 'finalizable', 'publisher-subscriber', 'pub-sub-callback-api', 'property-accessors-node', 'coffee-concerns'], (Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors) ->
      __root__.CoreObject = factory(__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors)

  # Server-side JavaScript Runtime compatible with CommonJS Module Spec
  else if typeof module is 'object' and module isnt null and typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(__root__, require('initializable'), require('finalizable'), require('publisher-subscriber'), require('pub-sub-callback-api'), require('property-accessors-node'), require('coffee-concerns'))

  # Browser, Web Worker and the rest
  else
    __root__.CoreObject = factory(__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors)

  # No return value
  return

)((__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors) ->
  class CoreObject
    @include Initializable
    @include Finalizable
    @include PropertyAccessors
    @include PublisherSubscriber
    @include Callbacks
    
    generateID = __root__._?.generateID ? do -> n = 0; (-> ++n)
  
    constructor: ->
      @oid = generateID()
      @initialize.apply(this, arguments)
  
    result: (property) ->
      value = this[property]
      if typeof value is 'function' then value.apply(this, arguments) else value
  
    @finalizer ->
      @notify('finalize', this)
      @stopListening()
      @off()
      this
)