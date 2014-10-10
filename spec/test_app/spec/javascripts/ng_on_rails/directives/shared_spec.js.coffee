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
    alert_message = 'alert message'
    el_string = '<button confirm="'+alert_message+'" action="console.log(123)"></button>'

    beforeEach inject ->
      element = angular.element(el_string)
      @compile(element) @scope
      @scope.$digest()

    it "test detect click event", ->
      test_msg = "testing without directive"
      click_tester = $(element)
      has_been_clicked = false
      click_tester.click ->
        has_been_clicked = true
        console.log(test_msg)

      console.log(1,has_been_clicked)
      browser_log = console.log
      console.log = jasmine.createSpy("log")
      click_tester.click()
      expect(console.log).toHaveBeenCalledWith(test_msg)
      console.log = browser_log
      console.log(2,has_been_clicked)

    xit "should have alert when clicked", ->
      browser_alert = alert
      alert = jasmine.createSpy()
      # somehow click element
      expect(alert).toHaveBeenCalledWith(alert_message)
      alert = browser_alert
    
    xit "execute action when clicked", ->
      jq_el = jQuery(element)
      console.log = jasmine.createSpy("log")
      # somehow click element
      expect(console.log).toHaveBeenCalledWith("this is a fake log not triggered by a click event")
