if Object.prototype.__defineGetter__ && !Object.defineProperty
  Object.defineProperty = (obj,prop,desc) ->
    if ("get" in desc) then obj.__defineGetter__(prop,desc.get)
    if ("set" in desc) then obj.__defineSetter__(prop,desc.set)

class RichReactor
  constructor: (properties) ->
    @keys = {}
    @keyDeps = {}
    @keyValueDeps = {}

    for property in properties
      @addProperty property

  get: (key)->
    contexts = @keyDeps[key] ?= new Meteor.deps._ContextSet()
    contexts.addCurrentContext()
    return @keys[key]
    
  set: (key, value)->
    @keys[key] = value
    @keyDeps[key]?.invalidateAll()
    console.log "setting value", key, value


  addProperty: (name)->
    console.log "adding property", name
    Object.defineProperty @, name,
      get: ->
        @.get(name)
        
      set: (value)->
        @.set(name, value)
