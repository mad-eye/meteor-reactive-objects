assert = chai.assert

describe 'ReactiveArray', ->
  describe 'basic operations', ->
    it 'should construct correctly', ->
      rarr = new ReactiveArray

    it 'should give correct length', ->
      rarr = new ReactiveArray ['a', 'b']
      assert.equal rarr.length, 2

    it 'should push/pull/shift/unshift correctly', ->
      rarr = new ReactiveArray
      rarr.push 'a'
      assert.equal rarr.length, 1
      rarr.push 'b'
      assert.equal rarr.length, 2
      rarr.push 'c'
      assert.equal rarr.length, 3
      assert.equal rarr.pop(), 'c'
      assert.equal rarr.length, 2
      assert.equal rarr.shift(), 'a'
      assert.equal rarr.length, 1
      rarr.unshift 'd'
      assert.equal rarr.length, 2
      assert.deepEqual rarr.array, ['d','b']

  describe 'length', ->
    it 'should react to pushes', ->
      rarr = new ReactiveArray
      len = null
      Meteor.autorun ->
        len = rarr.length
      rarr.push 'a'
      Meteor.flush()
      assert.equal len, 1

    it 'should react to pops', ->
      rarr = new ReactiveArray ['a']
      len = null
      Meteor.autorun ->
        len = rarr.length
      rarr.pop()
      Meteor.flush()
      assert.equal len, 0

    it 'should react to unshifts', ->
      rarr = new ReactiveArray
      len = null
      Meteor.autorun ->
        len = rarr.length
      rarr.unshift 'a'
      Meteor.flush()
      assert.equal len, 1

    it 'should react to shifts', ->
      rarr = new ReactiveArray ['a']
      len = null
      Meteor.autorun ->
        len = rarr.length
      rarr.shift()
      Meteor.flush()
      assert.equal len, 0


