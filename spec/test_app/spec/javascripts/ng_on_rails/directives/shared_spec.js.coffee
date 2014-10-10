#= require spec_helper

describe "NgOnRails Directives", ->
  element = undefined

  describe "renderView", ->
    render_el = '<div render_view="true" url="docs/index"></div>'

    beforeEach inject ->
      @http.when('GET', '/angular_app/docs/index.html').respond(200);
      element = angular.element(render_el)

    it "should load docs/index when compiled", ->
      @http.expectGET('/angular_app/docs/index.html')
      @compile(element) @scope
      @http.flush()