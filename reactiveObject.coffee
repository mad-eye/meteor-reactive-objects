if Object.prototype.__defineGetter__ && !Object.defineProperty
  Object.defineProperty = (obj,prop,desc) ->
    if ("get" in desc) then obj.__defineGetter__(prop,desc.get)
    if ("set" in desc) then obj.__defineSetter__(prop,desc.set)

class ReactiveObject
  constructor: (properties) ->
    @_keys = {}
    @_keyDeps = {}
    #@_keyValueDeps = {}

    if properties
      if properties instanceof Array
        for property in properties
          @_addProperty property
      else if 'object' == typeof properties
        for property, value of properties
          @_addProperty property
          if value instanceof Array
            @[property] = new ReactiveArray value
          else if 'object' == typeof value
            @[property] = new ReactiveObject value
          else
            #TODO: Handle functions and other non-scalar types
            @[property] = value


  _register: (key) ->
    contexts = @_keyDeps[key] ?= new Meteor.deps._ContextSet()
    contexts.addCurrentContext()

  _invalidate: (key) ->
    @_keyDeps[key]?.invalidateAll()

  _get: (key) ->
    @_register key
    return @_keys[key]
    
  _set: (key, value) ->
    @_keys[key] = value
    @_invalidate key
    #console.log "setting value", key, value


  _addProperty: (name)->
    #console.log "adding property", name
    Object.defineProperty @, name,
      get: ->
        @_get(name)
        
      set: (value)->
        @_set(name, value)


class ReactiveArray extends ReactiveObject
  constructor: (initialArray) ->
    @array = initialArray ? []
    @defineLength()
    super()

  defineLength: ->
    Object.defineProperty @, 'length',
      get: ->
        @_register 'length'
        @array.length
        
      set: (value)->
        @_invalidate 'length'
        @array.length = value

  push: (object) ->
    @_invalidate 'length'
    @array.push object

  pop: ->
    @_invalidate 'length'
    @array.pop()

  shift: ->
    @_invalidate 'length'
    @array.shift()

  unshift: (object) ->
    @_invalidate 'length'
    @array.unshift object

### Array methods
    concat()	Joins two or more arrays, and returns a copy of the joined arrays
indexOf()	Search the array for an element and returns it's position
join()	Joins all elements of an array into a string
lastIndexOf()	Search the array for an element, starting at the end, and returns it's position
pop()	Removes the last element of an array, and returns that element
push()	Adds new elements to the end of an array, and returns the new length
reverse()	Reverses the order of the elements in an array
shift()	Removes the first element of an array, and returns that element
slice()	Selects a part of an array, and returns the new array
sort()	Sorts the elements of an array
splice()	Adds/Removes elements from an array
toString()	Converts an array to a string, and returns the result
unshift()
###

class ReactiveForm extends ReactiveObject
  constructor: (selector) ->

