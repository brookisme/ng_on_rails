#= require spec_helper

describe "NgOnRails Directives", ->
  element = undefined
  beforeEach inject ->
    element = angular.element("<div eh-simple>{{2 + 2}}</div>")
    @compile(element) @scope

  it "should equal 4", ->
    console.log("element",element)
    console.log("scope",@scope)
    @scope.$digest()
    expect(element.html()).toBe "4"
