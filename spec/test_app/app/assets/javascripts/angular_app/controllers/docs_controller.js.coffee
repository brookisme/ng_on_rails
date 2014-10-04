NgOnRailsApp.controller 'DocsController', ($scope,Doc,Page,Bridge) ->
  # setup
  ctrl = this
  ctrl.bridge = Bridge
  ctrl.data = {}

  # initializers
  ctrl.setDoc = (doc)->
    ctrl.bridge.data.doc = doc
  ctrl.setDocs = (docs)->
    ctrl.bridge.data.docs = docs

  # rest methods
  ctrl.rest =
    index: ->
      params = {}
      Doc.query(params).$promise.then (docs) ->
        ctrl.bridge.data.docs = docs

    show: (doc_id)->
      Doc.get({id: doc_id}).$promise.then (doc) ->
        ctrl.bridge.data.doc = doc
        
    new: ()->
      ctrl.clear()
      ctrl.data.activeDoc = {}
      ctrl.data.creating_new_doc = true

    create: ->
      if !(ctrl.locked || ctrl.doc_form.$error.required)
        ctrl.locked = true
        working_doc = angular.copy(ctrl.data.activeDoc)
        Doc.save(
          working_doc,
          (doc)->
            ctrl.bridge.data.docs ||= []
            ctrl.bridge.data.docs.push(doc)
            ctrl.clear()
            ctrl.locked = false
          ,
          (error)->
            console.log("create_error:",error)
            ctrl.clear()
            ctrl.locked = false
        )


    edit: (doc) ->
      ctrl.clear()
      ctrl.data.activeDoc = doc
      ctrl.data.editing_doc = true

    update: (doc)->
      if !(ctrl.locked || ctrl.doc_form.$error.required)
        ctrl.locked = true
        doc = ctrl.data.activeDoc unless !!doc
        working_doc = angular.extend(angular.copy(doc),ctrl.data.activeDoc)
        Doc.update(
          working_doc,
          (doc)->
            # success handler
            ctrl.locked = false
          ,
          (error)->
            console.log("update_error:",error)
            ctrl.locked = false
        )
        ctrl.clear()

    delete: (index,doc,docs)->
      Doc.delete(
        doc, 
        (doc)->
          docs ||= ctrl.bridge.data.docs
          docs.splice(index,1)
        ,
        (error)->
          console.log("delete_error:",error)
      )
      ctrl.clear()


  # scope methods
  ctrl.toggleDetails = (doc)->
    doc.show_details = !doc.show_details

  ctrl.clear = ->
    ctrl.data.activeDoc = null
    ctrl.data.creating_new_doc = false
    ctrl.data.editing_doc = false

  ctrl.is_editing = (doc)->
    (ctrl.data.editing_doc && !!doc && doc.id == ctrl.data.activeDoc.id) ||
    (ctrl.data.creating_new_doc && !doc)

  # internal methods go here...

  # return
  return