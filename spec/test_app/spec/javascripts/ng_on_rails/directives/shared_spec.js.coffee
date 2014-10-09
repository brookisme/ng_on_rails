#= require spec_helper

describe "NgOnRails Directives", ->
  element = undefined

  describe "Hello World", ->
    render_el = '<div hello_world="true">{{2+2}}</div>'

    beforeEach inject ->
      element = angular.element(render_el)
      @compile(element) @scope

    it "compile content", ->
      @scope.$digest()
      expect(element.html()).toBe "4"

    it "should add a class of hello_world", ->
      expect(element.hasClass("hello_world")).toBe(true);
