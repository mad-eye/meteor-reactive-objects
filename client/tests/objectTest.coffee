assert = chai.assert

describe 'ReactiveObject', ->

  describe 'array constructor', ->
    it 'should construct ok', ->
      robj = new ReactiveObject

    it 'should make properties reactive on set', ->
      robj = new ReactiveObject ['foo']
      receivedValue = null
      Meteor.autorun ->
        receivedValue = robj.foo
      robj.foo = 'bar'
      Meteor.flush()
      assert.equal receivedValue, 'bar'

    it 'should make properties reactive on change', ->
      robj = new ReactiveObject ['a']
      aValue = null
      robj.a = 1
      Meteor.autorun ->
        aValue = robj.a
      assert.equal aValue, 1
      robj.a = 2
      Meteor.flush()
      assert.equal aValue, 2

    it 'should invalidate only the changed property', ->
      robj = new ReactiveObject ['a', 'b']
      aValue = null
      bValue = null
      robj.a = 1
      robj.b = 1

      alreadyRan = false
      Meteor.autorun ->
        aValue = robj.a
        assert.isFalse alreadyRan
        alreadyRan = true

      Meteor.autorun ->
        bValue = robj.b
      robj.b = 'bar'
      Meteor.flush()

      assert.equal bValue, 'bar'

  describe 'object constructor', ->
    robj = null
    before ->
      initialObject =
        a:
          b:
            c: 'C'
            d: 'D'
        e:
          f: 'F'
      robj = new ReactiveObject initialObject
    it 'should set the values', ->
      assert.equal robj.a.b.c, 'C'
      assert.equal robj.a.b.d, 'D'
      assert.equal robj.e.f, 'F'

    it 'should react to deep changes', ->
      value = null
      Meteor.autorun ->
        value = robj.a.b.c
      robj.a.b.c = 1
      Meteor.flush()
      assert.equal value, 1

    #it 'should invalidate higher contexts', ->
      #value = null
      #Meteor.autorun ->
        #value = robj.a.b
      #robj.a.b.c = 1
      #Meteor.flush()
      #assert.deepEqual value, {c:1}






