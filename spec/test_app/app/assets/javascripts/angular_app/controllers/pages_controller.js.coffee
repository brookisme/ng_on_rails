NgOnRailsApp.controller 'PagesController', ($scope,Page,Bridge) ->
  # setup
  ctrl = this
  ctrl.bridge = Bridge
  ctrl.data = {}

  # initializers
  ctrl.setPage = (page)->
    ctrl.bridge.data.page = page
  ctrl.setPages = (pages)->
    ctrl.bridge.data.pages = pages

  # rest methods
  ctrl.rest =
    index: ->
      params = {}
      Page.query(params).$promise.then (pages) ->
        ctrl.bridge.data.pages = pages

    show: (page_id)->
      Page.get({id: page_id}).$promise.then (page) ->
        ctrl.bridge.data.page = page
        ctrl.bridge.data.page_versions = page.page_versions

    new: (doc_id)->
      ctrl.clear()
      ctrl.bridge.data.pages ||= []
      ctrl.data.activePage = {}
      ctrl.data.activePage.order_index = ctrl.bridge.data.pages.length + 1
      ctrl.data.activePage.doc_id = doc_id
      ctrl.data.creating_new_page = true

    create: ->
      if !(ctrl.locked || ctrl.page_form.$error.required)
        ctrl.locked = true
        working_page = angular.copy(ctrl.data.activePage)
        Page.save(
          working_page,
          (page)->
            ctrl.bridge.data.pages ||= []
            ctrl.bridge.data.pages.push(page)
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
      page.show_details = false
      ctrl.data.activePage = page
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
          pages ||= ctrl.bridge.data.pages
          pages.splice(index,1)
        ,
        (error)->
          console.log("delete_error:",error)
      )
      ctrl.clear()


  # scope methods 
  ctrl.toggleDetails = (page)->
    page.show_details = !page.show_details

  ctrl.resort = (pages) ->
    for page, index in pages
      page.order_index = index + 1
      Page.update(
        page,
       (page)->
          # success handler
        ,
        (error)->
          console.log("update_error:",error)
        )

  ctrl.clear = ->
    ctrl.data.activePage = null
    ctrl.data.creating_new_page = false
    ctrl.data.editing_page = false

  ctrl.is_editing = (page)->
    (ctrl.data.editing_page && !!page && page.id == ctrl.data.activePage.id) ||
    (ctrl.data.creating_new_page && !page)

  # internal

  # return
  return