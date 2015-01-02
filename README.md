##### *This project is in active developement. MIT-LICENSE.*

-----------------------------------------------------------

### NgOnRails

*A Rails inspired framework for using AngularJS with Rails*

**IMPORTANT!!! The key parts of this project, namely the Rails-Service and the render(View) directives are working properly.  However there were some breaking changes with Angular 1.3 and I've been updating my thoughts on best practices. All this is leading to new ideas on how the generators should work.  Moreover, talk of Angular 2.0 has called into question the logic of continuing this project as it is now.  I'll be making updates so I can use it with projects I am personally working on but it probably won't be actively maintained until after Angular 2.0 comes out and there is a complete overhaul.**

**This project is in active development.  Check back often for updates and be very careful when using with any production app.**

This gem aims to standardize and simplify how AngularJS is integrated within a rails application. The hope is to push towards a *convention-over-configuration* approach with using AngularJS with rails.  

Key features include:
  * A [Rails-service](https://github.com/brookisme/ng_on_rails/wiki/Rails-Service) that automatically converts any instance variables to a json object that can be used
  * [Generators](#ngor_generators) to quickly create angular controllers/services/views/partials
  * [Directives](#ngor_directives) for rendering views and partials, and other useful view-content

##### Install it!
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

In your layout below the `javascript_include_tag "application"` load the Rails-service.
```html.erb
<script>
  = render( partial: 'angular_app/rails_service', formats: ['js'], locals: { ng_data: ng_data} )
</script>    
```
*See our wiki for an detailed layout [example](https://github.com/brookisme/ng_on_rails/wiki/Layouts).*

NgOnRails is now up and running!

_Instructions for using NgOnRails with a **Rails Engine** can be found [here](https://github.com/brookisme/ng_on_rails/wiki/Engines)._


<a name="#ngor_app_note"></a>
##### Note: NgOnRailsApp
An angular-app, NgOnRailsApp, is automatically created if it doesn't already exsit
```javascript
# ng_on_rails/app/assets/javascripts/app.js
if (!window.NgOnRailsApp){
  window.NgOnRailsApp = angular.module("NgOnRailsApp", ["ngResource","ngAnimate","ngSanitize"])
}
```
If you want to overide NgOnRailsApp, so you can inject your own providers,
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

-----------------------------------------------------------

### Conventions

NgOnRails expects that there is an "angular\_app" directory in your javascripts directory containing all of the controllers/directives/services you are going to use.  Simalarly, NgOnRails expects that there is an "angular\_app" directory in your views directory containing all the angular-views/partials. Naming/Path conventions follow what one would naturally expect from Rails.  

Example Directory Structure (*In this example the Rails app has 'Page' model*): 
```
|-- app/
  |-- assests/
    |-- javascripts/
      |-- angular_app/
       |-- controllers/
        |-- app_controller.js
        |-- pages_controller.js
       |-- directives/
       |-- services/
        |-page.js 
       |- app.js ([optional](#ngor_app_note))
  |-- views/
    |-- angular_app/
      |-- pages/
        |-- _page.html
        |-- _pages.html
        |-- _show.html
        |-- index.html
        |-- show.html
    |-- pages/
```

##### Things to note:
* Try to have as little AngularJS as possible outside of my angular_app folder.  Assuming there exists a rails "Page" model, handle the views like this:
```html
# your_app/app/views/pages/index.html
<!-- Apart from this render_view directive don't put any other angular in this file -->
<div render_view="true" url="pages/index" ng-init="pages=ctrl.rails.pages"></div>


# your_app/app/views/angular_app/pages/index.html
<div ng_controller="PagesController as ctrl">
  <div ng-repeat="page in pages">
    <div render='true' url='pages/page'>
    <div ng-show="ctrl.is_editing(page)">... 
```
* In the above, `ctrl.rails` has been set to the Rails-service in the AppController
* Use the Controller-As syntax!  I know there are people who aren't a fan.  However in most apps where I am using angular there is a complicated Model structure.   I necessarly want to edit all these things on a single page, though spread out through many partials. Controller-As really really helps keep the logic clear.

These conventions can be easily followed (directories will be generated) if you use the NgOnRails [generators](#ngor_generators).  

*See [test_app](https://github.com/brookisme/ng_on_rails/tree/master/spec/test_app) for an example of these conventions.*

-----------------------------------------------------------

<a name="ngor_generators"></a>
### Generators

You can quickly your project up and running using the NgOnRails generators:
  * ng_on_rails:layout - generates layout files in your\_app/app/views/layouts/
  * ng_on_rails:jbuilder - generates jbuilder files in your\_app/app/views/model\_plural\_name/
  * ng_on_rails:controller - generates an ng-controller in your\_app/app/assests/javascripts/angular\_app/controllers/
  * ng_on_rails:resource - generates a ng-resource-service in your\_app/app/assests/javascripts/angular\_app/services/
  * ng_on_rails:views - generates views in your\_app/app/views/angular\_app/model_plural_name/
  * ng_on_rails:scaffold - all of the above

Here is a brief overview of many of the options available
```
$ bundle exec rails g ng_on_rails:scaffold --help

Usage:
  rails generate ng_on_rails:scaffold MODEL_NAME [options]

Options:
  [--properties=one two three]               # list of properties
  [--relationships=one two three]            # list of relationships. determines has_many/one from singular/plural name
  [--format=FORMAT]                          # *** FOR NOW ONLY OFFERS SLIM*** templating engine. defaults to slim. slim, haml, erb
                                             # Default: slim
  [--render-views], [--no-render-views]      # Insert render_view directives into rails-views
                                             # Default: true
  [--jbuilder], [--no-jbuilder]              # Create jbuilder files the rails-views directory for json
  [--rails-views], [--no-rails-views]        # Insert both render_views and jbuilder files in rails-views
  [--belongs-to=one two three]               # list of models it belongs_to
  [--overwrite], [--no-overwrite]            # overwrite file if it exist
  [--layout], [--no-layout]                  # create layout
                                             # Default: true
  [--app-controller], [--no-app-controller]  # create app_controller
                                             # Default: true
  [--build], [--no-build]                    # BUILD as ng_data default
                                             # Default: true
  [--layout-name=LAYOUT_NAME]                # name of layout. defaults to 'application', creating the file application.html.<format>
                                             # Default: application
  [--styles], [--no-styles]                  # add ng_on_rails_styles.css
                                             # Default: true
```
* `--properties` is a list of properties you want in the views. A property looks like `property_name:property_type{opt1+opt2+...}`.
  * property\_name: (required) name of the property 
  * property\_type: (optional) number/textarea -- default empty
  * opt-list: (optional) seperate options by "+".  the allowed values are:
    * required: make the property required in the form
    * skip_form: do not include in the form
    * skip_index: do not include in the index table row
    * link: link this property in index table to the show view

  A typical example might look like this
```
bundle exec rails g ng_on_rails:views Doc --properties id:number{skip_form+link} name{required} description:textarea{skip_index}
```
* `--render-views=true` will append (creating file if necessary) code to load the angular views to your index and show views in your views directory.  For example, your index files becomes:
```slim
# your_app/app/views/docs/index.html.slim

... your content ...

/ 
/ Inserted by NgOnRails view generator.
/ 
div ng-init="docs=ctrl.rails.docs" render_view="true" url="docs/index"
/
/
/
```
* `--belongs_to` In the controller generator it will will ensure that belongs to relationships are set in the "rest.new()" and "rest.edit()" methods. In the views it will ensure that the correct id's for these models get passed in the right order.
* `--styles` Copies a simple NgOnRails stylesheet into your stylesheets directory.  This will make the views look slightly nicer.  *Note: The generated views are fine without additional frameworks but have been written to use both [bootstrap](http://getbootstrap.com/) and [fontAwesome](http://fortawesome.github.io/Font-Awesome/).*

##### Test App
The [test_app](https://github.com/brookisme/ng_on_rails/tree/master/spec/test_app) serves as an example of how to use these generators. With one minor alteration the test app was generated with the following commands:
```
$ bundle exec rails g ng_on_rails:layout
$ bundle exec rails g ng_on_rails:resource Doc
$ bundle exec rails g ng_on_rails:controller Doc
$ bundle exec rails g ng_on_rails:jbuilder Doc id name description pages --overwrite=true
$ bundle exec rails g ng_on_rails:views Doc --properties id:number{skip_form+link} name{required} description:textarea{skip_index} --relationships pages --rails-views
$ bundle exec rails g ng_on_rails:resource Page
$ bundle exec rails g ng_on_rails:controller Page --belongs_to Doc
$ bundle exec rails g ng_on_rails:jbuilder Page
$ bundle exec rails g ng_on_rails:views Page --properties id:number{skip_form+link} order_index:number subject{required} body:textarea{skip_index} --belongs_to Doc --rails-views
```
or even better, in two lines with the scaffolding short hand:
```
$ bundle exec rails g ng_on_rails:scaffold Doc --properties id:number{skip_form+link} name{required} description:textarea{skip_index} --relationships pages --rails-views
$ bundle exec rails g ng_on_rails:scaffold Page --properties id:number{skip_form+link} order_index:number subject{required} body:textarea{skip_index} --belongs_to Doc --rails-views
```

-----------------------------------------------------------

<a name="ngor_directives"></a>
### Render Directives

As in Rails partials are prefixed with and underscore ("\_").  Partials should be loaded with the render directive. The 'views' should be loaded with the render\_view directive.  The main distinguishing factor between views and partials are if they load a angular controller.   

Here is an example: The first file is a 'view', the index view for a Doc model, and the second is partial that displays information on the doc.
```slim
# VIEW:  your_app/app/views/angular_app/docs/index.html.slim
div ng_controller="DocsController as ctrl" ng-init="ctrl.setDocs(docs)"
  .div-table
    .tr.header
      .td.id ID
      .td.name NAME
      .td ...

# PARTIAL:  your_app/app/views/angular_app/docs/_doc.html.slim
h3 Doc Details
h5 
  | ID:
  span ng-bind="doc.id"
h5 CREATED AT
div ng-bind="doc.created_at"
h5 DESCRIPTION
div ng-bind="doc.description"
```
Note that using distinguishing characterisic of loading the controller via `ng_controller` loading layout is parallel to how views and partials are distinguished in rails.

-----------------------------------------------------------

<a name="test_app"></a>
### Test App
The [test_app](https://github.com/brookisme/ng_on_rails/tree/master/spec/test_app) can be used as an example application.  A some details to mention:
* The DB is Postgres
* The (Angular) Views use Slim
* The JS uses CoffeeScript (except for _rails_service.js.erb -- where I need access to Rails)
* Much of app/views/angular_app & app/assests/javascripts/angular_app has been cut and pasted in from a different 
* The CSS uses both bootstrap and font-awesome 





