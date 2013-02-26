if Object.prototype.__defineGetter__ && !Object.defineProperty
  Object.defineProperty = (obj,prop,desc) ->
    if ("get" in desc) then obj.__defineGetter__(prop,desc.get)
    if ("set" in desc) then obj.__defineSetter__(prop,desc.set)

class ReactiveObject
  constructor: (properties) ->
    @keys = {}
    @keyDeps = {}
    @keyValueDeps = {}

    for property in properties
      @addProperty property

  register: (key) ->
    contexts = @keyDeps[key] ?= new Meteor.deps._ContextSet()
    contexts.addCurrentContext()

  invalidate: (key) ->
    @keyDeps[key]?.invalidateAll()

  get: (key) ->
    @register key
    return @keys[key]
    
  set: (key, value) ->
    @keys[key] = value
    @invalidate key
    console.log "setting value", key, value


  addProperty: (name)->
    console.log "adding property", name
    Object.defineProperty @, name,
      get: ->
        @.get(name)
        
      set: (value)->
        @.set(name, value)

class ReactiveArray extends ReactiveObject
  constructor: (initialArray) ->
    @array = []
    @defineLength
    @push x for x in initialArray

  defineLength: ->
    Object.defineProperty @, 'length',
      get: ->
        @register 'length'
        @array.length
        
      set: (value)->
        @invalidate 'length'
        @array.length = value
    
    
  push: (object) ->
    @invalidate 'length'
    @array.push object
    
  pop: ->
    @invalidate 'length'
    @array.pop

  shift: (object) ->
    @invalidate 'length'
    @array.shift object

  unshift: ->
    @invalidate 'length'
    @array.unshift

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
