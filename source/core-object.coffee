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
    if typeof value is 'function' 
      args = []
      i    = 0
      l    = arguments.length
      args.push(arguments[i]) while ++i < l
      value.apply(this, args)
    else
      value

  @finalizer ->
    @notify('finalize', this)
    @stopListening()
    @off()
    this

  @VERSION: '1.1.1'
