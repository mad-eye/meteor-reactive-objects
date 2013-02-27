assert = chai.assert

describe 'ReactiveForm', ->
  describe 'without template', ->

    it 'should populate with simple values', ->
      rform = new ReactiveForm "#theForm"
      assert.equal rform.pet, 'Cat'

    it 'should populate array values', ->
      rform = new ReactiveForm "#theForm"
      foodVals = rform.food
      assert.equal foodVals.length, 2
      assert.isTrue 'carrot' in foodVals
      assert.isTrue 'banana' in foodVals


  describe 'with template', ->
    it 'should populate with simple values', ->
      rform = new ReactiveForm '#theForm', Template.formBox
      assert.equal rform.pet, 'Cat'

    it 'should populate array values', ->
      rform = new ReactiveForm '#theForm', Template.formBox
      foodVals = rform.food
      assert.equal foodVals.length, 2
      assert.isTrue 'carrot' in foodVals
      assert.isTrue 'banana' in foodVals

    #it 'should react to changes in form', (done) ->
      #console.log "Running form change test"
      #rform = new ReactiveForm '#theForm', Template.formBox
      #$('#petInput').val('Dog')
      #$('#petInput').change()

      #console.log "Pet input now has value", $('#petInput').val()
      ##assert.equal rform.pet, 'Dog'
      
