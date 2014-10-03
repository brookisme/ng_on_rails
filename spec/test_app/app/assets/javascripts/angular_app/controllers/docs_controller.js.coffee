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
      ctrl.data.activeDoc.order_index = new_order_index()
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
  ctrl.addPages = (doc)->
    doc.page_ids = []
    added_pages = []
    for page in ctrl.bridge.data.admin_pages
      if page.add_this_page
        console.log("add pg",page.name)
        doc.page_ids.push(page.id)
        added_pages[page]
    Doc.update(
      doc,
      (doc)->
        console.log("success",doc.pages)
      ,
      (error)->
        console.log("addpages error:",error)
    )

  ctrl.toggleDetails = (doc)->
    doc.show_details = !doc.show_details

  ctrl.resort = (docs) ->
    for doc, index in docs
      doc.order_index = index + 1
      Doc.update(
        doc,
       (doc)->
          # success handler
        ,
        (error)->
          console.log("update_error:",error)
        )

  ctrl.clear = ->
    ctrl.data.activeDoc = null
    ctrl.data.creating_new_doc = false
    ctrl.data.editing_doc = false

  ctrl.is_editing = (doc)->
    (ctrl.data.editing_doc && !!doc && doc.id == ctrl.data.activeDoc.id) ||
    (ctrl.data.creating_new_doc && !doc)

  # internal
  new_order_index = ()->
    length = ctrl.bridge.data.docs.length
    last_doc = ctrl.bridge.data.docs[length-1]
    if !!last_doc && !!last_doc.order_index
      last_doc.order_index + 1
    else
      length + 1

  # return
  return