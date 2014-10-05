NgOnRailsApp.controller 'PagesController', ($scope,Page,Rails) ->
  #
  # CONTROLLER SETUP
  #
  ctrl = this
  ctrl.rails = Rails
  ctrl.data = {}


  #
  # INITIALIZERS
  #
  ctrl.setPage = (page)->
    ctrl.data.page = page
  ctrl.setPages = (pages)->
    ctrl.data.pages = pages


  #  
  # REST METHODS
  #
  ctrl.rest =
    index: ->
      params = {}
      Page.query(params).$promise.then (pages) ->
        ctrl.data.pages = pages

    show: (page_id)->
      Page.get({id: page_id}).$promise.then (page) ->
        ctrl.data.page = page
        
    new: (doc_id)->
      ctrl.clear()
      ctrl.data.activePage = {}
      #
      #  NOTE: 
      #    setting of order_index/doc_id were 
      #    added after generating this file:
      #    $ bundle exec rails g ng_on_rails:controller Page
      #
      ctrl.data.activePage.order_index = ctrl.data.pages.length + 1
      ctrl.data.activePage.doc_id = doc_id
      ctrl.data.creating_new_page = true

    create: ->
      if !(ctrl.locked || ctrl.page_form.$error.required)
        ctrl.locked = true
        working_page = angular.copy(ctrl.data.activePage)
        Page.save(
          working_page,
          (page)->
            ctrl.data.pages ||= []
            ctrl.data.pages.push(page)
            ctrl.clear()
            ctrl.locked = false
          ,
          (error)->
            console.log("create_error:",error)
            ctrl.clear()
            ctrl.locked = false
        )

    edit: (page,doc_id) ->
      ctrl.clear()
      ctrl.data.activePage = page
      #
      #  NOTE: 
      #    setting of doc_id was added
      #    after generating this file:
      #    $ bundle exec rails g ng_on_rails:controller Page
      #
      ctrl.data.activePage.doc_id = doc_id
      ctrl.data.editing_page = true

    update: (page)->
      if !(ctrl.locked || ctrl.page_form.$error.required)
        ctrl.locked = true
        page = ctrl.data.activePage unless !!page
        working_page = angular.extend(angular.copy(page),ctrl.data.activePage)
        Page.update(
          working_page,
          (page)->
            # success handler
            ctrl.locked = false
          ,
          (error)->
            console.log("update_error:",error)
            ctrl.locked = false
        )
        ctrl.clear()

    delete: (index,page,pages)->
      Page.delete(
        page, 
        (page)->
          pages ||= ctrl.data.pages
          pages.splice(index,1)
        ,
        (error)->
          console.log("delete_error:",error)
      )
      ctrl.clear()


  #    
  # SCOPE METHODS
  #
  ctrl.clear = ->
    ctrl.data.activePage = null
    ctrl.data.creating_new_page = false
    ctrl.data.editing_page = false

  ctrl.is_editing = (page)->
    (ctrl.data.editing_page && !!page && page.id == ctrl.data.activePage.id) ||
    (ctrl.data.creating_new_page && !page)


  #  
  # PRIVATE METHODS
  #   
  # => add methods here, not attached to the ctrl object to be used internally
  #   


  #
  # END
  #
  return