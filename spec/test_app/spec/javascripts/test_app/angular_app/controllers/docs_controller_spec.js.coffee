#= require spec_helper

describe "DocsController", ->
  ctrl = undefined

  stub_doc = (id)->
    {id: id, name: 'Doc'+id, description: 'A description for doc_'+id}

  stub_Rails = 
    docs: [stub_doc(1),stub_doc(2),stub_doc(3)]
    doc: stub_doc(4)

  beforeEach inject ->
    ctrl = @controller 'DocsController', {
      '$scope': @scope,
      'Rails': stub_Rails
    }

  it 'should set ctrl.rails', ->
    expect(ctrl.rails).toBe(stub_Rails)

  #
  # INITIALIZERS
  #
  describe 'setDocs', ->
    it 'should set ctrl.data.docs', ->
      expect(ctrl.data.docs).toBe(undefined)
      ctrl.setDocs(stub_Rails.docs)
      expect(ctrl.data.docs).toBe(stub_Rails.docs)

  describe 'setDoc', ->
    it 'should set ctrl.data.doc', ->
      expect(ctrl.data.doc).toBe(undefined)
      ctrl.setDoc(stub_Rails.doc)
      expect(ctrl.data.doc).toBe(stub_Rails.doc)

  #  
  # REST METHODS
  #
  describe 'rest object', ->
    it 'should have a rest object', ->
      expect(ctrl.rest).toBeTruthy()

    describe 'rest.index', ->
    describe 'rest.show', ->
    describe 'rest.new', ->
      it 'should create empty ctrl.data.activeDoc', ->
        ctrl.data.activeDoc = undefined
        ctrl.rest.new()
        expect(ctrl.data.activeDoc).toEqual({})

      it 'should set ctrl.data.creating_new_doc to true', ->
        ctrl.data.creating_new_doc = false
        ctrl.rest.new()
        expect(ctrl.data.creating_new_doc).toBe(true)

    describe 'rest.create', ->
    describe 'rest.edit', ->
      doc = stub_doc(1)

      it 'should set ctrl.data.activeDoc to doc', ->
        ctrl.data.activeDoc = undefined
        ctrl.rest.edit(doc)
        expect(ctrl.data.activeDoc).toEqual(doc)

      it 'should set ctrl.data.editing_doc to true', ->
        ctrl.data.editing_doc = false
        ctrl.rest.edit(doc)
        expect(ctrl.data.editing_doc).toBe(true)

      it 'should set doc.is_displayed to false', ->
        doc.is_displayed = true
        ctrl.rest.edit(doc)
        expect(doc.is_displayed).toBe(false)

    describe 'rest.update', ->
    describe 'rest.delete', ->


  #    
  # SCOPE METHODS
  #
  describe 'clear', ->
    it 'should set data.activeDoc to null', ->
      ctrl.data.activeDoc = 1
      expect(ctrl.data.activeDoc).toBe 1
      ctrl.clear()
      expect(ctrl.data.activeDoc).toBe null
    it 'should set data.creating_new_doc to false', ->
      ctrl.data.creating_new_doc = 1
      expect(ctrl.data.creating_new_doc).toBe 1
      ctrl.clear()
      expect(ctrl.data.creating_new_doc).toBe false
    it 'should set data.editing_doc to false', ->
      ctrl.data.editing_doc = 1
      expect(ctrl.data.editing_doc).toBe 1
      ctrl.clear()
      expect(ctrl.data.editing_doc).toBe false    


  describe 'is_editing', ->
    
    doc = stub_doc(5)
    it 'should display be false if not editing', ->
      ctrl.data.editing_doc = false
      expect(ctrl.is_editing(doc)).toBeFalsy()

    it 'should display be false if editing but not this doc', ->
      ctrl.data.editing_doc = true
      ctrl.data.activeDoc = stub_doc(6)
      expect(ctrl.is_editing(doc)).toBeFalsy()

    it 'should display be true if editing this doc', ->
      ctrl.data.editing_doc = true
      ctrl.data.activeDoc = stub_doc(5)
      expect(ctrl.is_editing(doc)).toBeTruthy()

  describe 'toggleDisplay', ->
    it 'should toggle doc.is_displayed', ->
      doc = stub_doc(7)
      expect(doc.is_displayed).toBe undefined
      ctrl.toggleDisplay(doc)
      expect(doc.is_displayed).toBe true
      ctrl.toggleDisplay(doc)
      expect(doc.is_displayed).toBe false
      ctrl.toggleDisplay(doc)
      expect(doc.is_displayed).toBe true




