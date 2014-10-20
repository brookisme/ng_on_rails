### v0.0.1
* initial release

### v0.0.1.1
* change homepage to github repo

### v0.0.1.2
* require angular in engine.rb
* added models/views to test_app as example

### v0.0.2
* introduce render\_view directive: render now uses ng-'partials' (whose name begins with '\_'). render\_view is now used for ng-'views'.  both directives now have a format option that defaults to 'html'

### v0.0.3
* generators for ng controllers/resource-services added

### v0.0.3.1
* genrators for ng views (and styles)
* ng controller generator now has a belongs_to option

### v0.0.3.2
* genrators for ng layout, jbuilder, scaffold
* readme overhaul

### v0.0.3.3
* angular specs added

### v0.0.3.4
* belongs\_to\_parameter bug
* removed test button element

### v0.0.3.5
* No longer require setting mangle to false
* bug fix: controller_template - use correct relationship names in new.edit
* bug fix: jbuilder_template - ensure underscore for relationship names

### v0.0.3.6
* support for rails engines
* bug fix: controller_template - use correct relationship names in rest.edit