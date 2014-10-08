describe "NgOnRails Directives  ", ->
  element = undefined
  $scope = undefined
  beforeEach module("NgOnRailsApp")
  beforeEach inject(($compile, $rootScope) ->
    $scope = $rootScope
    element = angular.element("<div render='true'></div>")
    $compile(element) $rootScope
    return
  )
  it "should equal 4", ->
    $scope.$digest()
    expect(element.html()).toBe "4"
    return

  describe "ehSimple", ->
    it "should add a class of plain", ->
      expect(element.hasClass("plain")).toBe true
      return
      
    return

  return
