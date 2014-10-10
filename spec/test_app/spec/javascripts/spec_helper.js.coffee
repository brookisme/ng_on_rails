#= require application
#= require angular-mocks

beforeEach(module('NgOnRailsApp'))
 
beforeEach inject (_$httpBackend_, _$compile_, $rootScope, $controller, $location, $injector, $timeout, $templateCache) ->
  @scope = $rootScope.$new()
  @http = _$httpBackend_
  @compile = _$compile_
  @location = $location
  @controller = $controller
  @injector = $injector
  @timeout = $timeout
  @templateCache = $templateCache
  @model = (name) =>
    @injector.get(name)
  @eventLoop =
    flush: =>
      @scope.$digest()

afterEach ->
  @http.resetExpectations()
  @http.verifyNoOutstandingExpectation()