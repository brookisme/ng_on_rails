##### *This project is still in developement and uses MIT-LICENSE.*

-----------------------------------------------------------

### NgOnRails

*A Rails inspired framework for using AngularJS with Rails*

The main motivations behind this gem is to standardize and simplify how AngularJS is integrated in a rails  application.

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
"rails_service.js.erb" calls the `locals_to_json` helper method to automatically turn instance variables into json.Here `ng_data` is a local rails variable used to customize how this is converted. This will be discussed in detail below.
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




