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
