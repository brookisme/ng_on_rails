#= require spec_helper

describe "NgOnRails Directives", ->
  element = undefined


  #
  #  Render Directives
  #
  describe "renderView", ->
    el_string = '<div render_view="true" url="docs/index"></div>'

    beforeEach inject ->
      @http.when('GET', '/angular_app/docs/index.html').respond(200);
      element = angular.element(el_string)

    it "should render view", ->
      @http.expectGET('/angular_app/docs/index.html')
      @compile(element) @scope
      @http.flush()

  describe "render", ->
    el_string = '<div render="true" url="docs/doc"></div>'

    beforeEach inject ->
      @http.when('GET', '/angular_app/docs/_doc.html').respond(200);
      element = angular.element(el_string)

    it "should render partial", ->
      @http.expectGET('/angular_app/docs/_doc.html')
      @compile(element) @scope
      @http.flush()


  #
  #  ViewHelper Directives
  #
  describe "confirm", ->
    el_string = '<button confirm="confirm-message" action="console.log(123)"></button>'

    beforeEach inject ->
      element = angular.element(el_string)
      @compile(element) @scope

    xit "should have alert when clicked", ->
    xit "execute action when clicked", ->

