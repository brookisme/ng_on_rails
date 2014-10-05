NgOnRailsApp.controller 'DocsController', ($scope,Doc,Rails) ->
  #
  # CONTROLLER SETUP
  #
  ctrl = this
  ctrl.rails = Rails
  ctrl.data = {}


  #
  # INITIALIZERS
  #
  ctrl.setDoc = (doc)->
    ctrl.data.doc = doc
  ctrl.setDocs = (docs)->
    ctrl.data.docs = docs


  #  
  # REST METHODS
  #
  ctrl.rest =
    index: ->
      params = {}
      Doc.query(params).$promise.then (docs) ->
        ctrl.data.docs = docs

    show: (doc_id)->
      Doc.get({id: doc_id}).$promise.then (doc) ->
        ctrl.data.doc = doc
        
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
            ctrl.data.docs ||= []
            ctrl.data.docs.push(doc)
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
          docs ||= ctrl.data.docs
          docs.splice(index,1)
        ,
        (error)->
          console.log("delete_error:",error)
      )
      ctrl.clear()


  #    
  # SCOPE METHODS
  #
  ctrl.clear = ->
    ctrl.data.activeDoc = null
    ctrl.data.creating_new_doc = false
    ctrl.data.editing_doc = false

  ctrl.is_editing = (doc)->
    (ctrl.data.editing_doc && !!doc && doc.id == ctrl.data.activeDoc.id) ||
    (ctrl.data.creating_new_doc && !doc)

  ctrl.toggleDetails = (doc)->
    #
    #  NOTE: 
    #    ctrl.toggleDetails was added after generating this file:
    #    $ bundle exec rails g ng_on_rails:controller Page
    #
    doc.show_details = !doc.show_details


  #  
  # PRIVATE METHODS
  #   
  # => add methods here, not attached to the ctrl object to be used internally
  #   


  #
  # END
  #
  return