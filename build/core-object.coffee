((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self?.self is self
    self

  # Server
  else if typeof global is 'object' and global?.global is global
    global

  # AMD
  if typeof define is 'function' and define.amd
    define ['callbacks', 'publisher-subscriber', 'construct-with', 'property-accessors', 'coffee-concerns', 'exports'], (Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors) ->
      root.CoreObject = factory(root, Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors)

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          module.exports? and typeof module.exports is 'object'
    module.exports = factory(root, require('callbacks'), require('publisher-subscriber'), require('construct-with'), require('property-accessors'), require('coffee-concerns'))

  # Browser and the rest
  else
    root.CoreObject = factory(root, root.Callbacks, root.PublisherSubscriber, root.ConstructWith, root.PropertyAccessors)

  # No return value
  return

)((__root__, Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors) ->
  class CoreObject
    @include Callbacks
    @include PublisherSubscriber
    @include ConstructWith
    @include PropertyAccessors
  
    generateID = __root__._?.generateID ? do -> n = 0; (-> ++n)
  
    constructor: (parameters) ->
      @oid        = generateID()
      @destroyed  = no
      @destroying = no
      @initialize(parameters)
  
    result: (property) ->
      value = this[property]
      if typeof value is 'function' then this[property]() else value
  
    toString: ->
      (@constructor.name or '<Class name not available>') + "##{@oid}"
  
    destroy: (options) ->
      unless @destroyed
        @destroying = yes
  
        # Run destructor
        @destructor?(options)
  
        # Event destroy
        @notify('destroy', this)
  
        # Remove own event subscriptions
        @stopListening()
  
        # Remove outer event subscriptions
        @off()
  
        @options    = null
        @destroyed  = yes
        @destroying = no
      this
  
)