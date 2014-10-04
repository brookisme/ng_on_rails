##### *This project is still in developement and uses MIT-LICENSE.*

-----------------------------------------------------------

### NgOnRails

*A Rails inspired framework for using AngularJS with Rails*

The main motivations behind this gem is to standardize and simplify how AngularJS is integrated in a rails  application.  

I am just getting started but this does function *as-is*.  Some things left to do:
* Write more specs!!!
* Create generators for controllers/services/(views?)
* (ViewHelper functions via shared service?)

### Install it!
```
# Gemfile
gem 'ng_on_rails'

# your_app/app/assets/javascripts/application.js
//
//= require angular
//= require angular-resource
//= require angular-animate
//= require angular-sanitize
//= require ng_on_rails
//= require_tree .
```

Note: NgOnRailsApp is automatically created if it doesn't already exsit
```javascript
# app/assets/javascripts/app.js
if (!window.NgOnRailsApp){
  window.NgOnRailsApp = angular.module("NgOnRailsApp", ["ngResource","ngAnimate","ngSanitize"])
}
```
If you want to overide NgOnRailsApp - so you can inject your own providers
Just incldue a app.js file that defines NgOnRailsApp in your own app and load it **before** ng\_on\_rails
```javascript
# your_app/app/assets/javascripts/angular_app/app.js 
window.NgOnRailsApp = angular.module("NgOnRailsApp", ["ngResource","ngAnimate","ngSanitize","angular-sortable-view"])

# your_app/app/assets/javascripts/application.js
//= require ...
//= require angular_app/app.js
//= require ng_on_rails
//= require tree.
```

I would love feed back (especially on convention choices) and possibly other contributers.  Send me a note!

#### Overview

As time goes on generators for angular controllers and services (rails-models) will be added, as well as some view helpers and directives.  For the time being however the the gem is rather simple.

It relies on two pieces of slight magic

* a "Rails" service that holds all your rails variables.  This service automatically turns rails instance variables into json that can be used by Angular. For example the rails instance variable `@pages` will get mapped to `Rails.pages` that can be used by angular
```
<div ng-repeat="page in Rails.pages">...
```
To get this work you simply need to load the rails_service.js.erb partial
```html.erb
<script>
  = render( partial: 'angular_app/rails_service', formats: ['js'], locals: { ng_data: ng_data} )
</script>    
```
"rails_service.js.erb" calls the `locals_to_json` helper method to automatically turn instance variables into json.  Here `ng_data` is a local rails variable used to customize how this is converted. This will be discussed in detail [below](#locals_to_json).

* Your angular views(partials) should be placed in app/views/angular_app.  This solution is discussed in a handfull of places including [here](http://stackoverflow.com/questions/12116476/rails-static-html-template-files-in-the-asset-pipeline-and-caching-in-developmen), but the key parts are:
```ruby
# routes.rb
scope :angular_app do
    get ':path.html' => 'ng_on_rails#template', constraints: { path: /.+/ }
end

# ng_on_rails_controller.rb
def template
  @path = params[:path]
  render template: '/angular_app/' + @path, layout: nil
end
```
You can then use the angular directive 'render'
```javascript
NgOnRailsApp.directive(
  "render", 
  function(){
    return {
      restrict: "AE",
      transclude: true,
      template: function(el,attrs){
        return '<div ng_include="\'/angular_app/'+attrs.url+'.html\'"></div>'
      }
    }
  }
)
```
to load your angualar views in at 'app/views/angular_app'

#### Conventions

The test_app serves as an example of the conventions discussed below, but before looking it over read [this](#test_app).

* Put Angular controllers/directives/... in a folder "angular\_app" in the assets directory.  Similarly, as discussed above, the angular views(partials) are placed in a folder "angular\_app" in the views directory
```
|-- app/
  |-- assests/
    |-- javascripts/
      |-- angular_app/
       |-- controllers/
       |-- directives/
       |-- services/
       |- app.js
  |-- views/
    |-- angular_app/

```
Files should be named/put in folders in the same maner that you would in Rails.  For instance, if you have a Page model, you would have a pages_controller.js and a service page.js. Then under views you would have pages/{show.html,index.html,...}.  *The way these views are handled makes them more like partials that views but for now at least I am not prefixing the name with and underscore  "\_"*

* As for views, I try to have as little AngularJS outside of my angular_app folder.  I will load the "Rails" service and set `ng-app="NgOnRailsApp"` in the application layout.  Additionally I will usuallly have an angular `AppController` that is very limited in behavior that is part of the application layout.  Again assuming I have a "Page" model I will handle the views like this

```html
# app/views/pages/index.html
<!-- Apart from this render directive don't put any other angular in this file -->
<div render="true" url="pages/index" ng-init="pages=ctrl.rails.pages"></div>


# app/views/angular_app/pages/show.html
<div ng_controller="PagesController as ctrl">
  <div ng-repeat="page in pages">
    <div ng-show="ctrl.is_editing(page)">... 
```
*In the above, `ctrl.rails` has been set to the Rails service in the AppController*

* This brings up another point.  Use the Controller-As syntax!  I know there are people who aren't a fan.  However in most apps where I am using angular there is a complicated Model structure.   I necessarly want to edit all these things on a single page, though spread out through many partials. Controller-As really really helps keep the logic clear.


#### Angular Services for Rails Models
You are going to have a service for each rails model.  I plan on adding generators but for now this is what my services look like

```coffeescript
# app/assets/javascripts/angular_app/services/page.js.coffee
NgOnRailsApp.factory "Page", ($resource) ->
  PageResource = $resource "/questions/:id.json", {id: "@id"}, {
    update:{method: "PUT"}
  }
  class Page extends PageResource
    # place class and instance methods here if you want them.
```


#### Angular Controllers for Rails Models
Simalarly you are going to have an angular controller for each rails model.  Again, I plan on adding generators but for now an example is below.  Note that I place all the REST methods in a rest object.  Bridge is a service I use to pass data from one controller to another.

```coffeescript
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
      ctrl.data.activePage = {}
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

  # private methods
  some_private_method = ->
    console.log('nobody knows i exist') 
  
  return
```
<a name="locals_to_json"></a>
#### Rails variables to Angular-able json.

As mentioned using the Rails-service you can get access to all your rails variables in angular.  
```html.erb
<script>
  = render( partial: 'angular_app/rails_service', formats: ['js'], locals: { ng_data: ng_data} )
</script>    
```
Here, ng_data is a local rails variable that describes how to create the json:

* if ng_data is nil all varibles will be converted with `.to_json` ( or if its a string/numeric with .to_s )
* if `ng_data['BUILD'].blank?` the default will be to use `.to_json` for conversion.
* if `ng_data['BUILD']=true` the default will be to look for a `.json` file in the app/views directory. It will guess the name and path to this file using the name of var. For instance, if we have @page it will look for the the file app/views/pages/page.json.
* if `ng_data[var_name].blank?` the conversion will use the default discussed above
* if `ng_data[var_name]={ path: 'path/to/file', as: model_name } it will use this info to try and find the build file.  For instance, suppose I have a collection of pages called `@admin_pages`. Then `ng_data['admin_pages'] = { path: "pages/pages", as: :pages }` will look for the file app/views/pages/pages.json seting the local variable `pages = @admin_pages`.

To understand it better look at [ng_on_rails_helper.rb](https://github.com/brookisme/ng_on_rails/blob/master/app/helpers/ng_on_rails_helper.rb).

<a name="test_app"></a>
#### Test App
The [test_app](https://github.com/brookisme/ng_on_rails/blob/master/app/spec/test_app) can be used as an example application.  A some details to mention:

* The DB is Postgres
* The (Angular) Views use Slim
* The JS uses CoffeeScript (except for _rails_service.js.erb -- where I need access to Rails)
* Much of app/views/angular_app & app/assests/javascripts/angular_app has been cut and pasted in from a different project and the models have been generated with Rails scaffolding.  This leads to a few oddities:
  * There is a mixture of both erb and slim
  * The full scaffolding has been left in but the Angular views are contained solely withing the docs-index and doc-show pages.
  * Though there is limited CSS but I use both bootstrap and font-awesome 





