##### *This project is still in developement and uses MIT-LICENSE.*

-----------------------------------------------------------

### NgOnRails

* A Rails inspired framework for using AngularJS with Rails *

The main motivations behind this gem is to standardize and simplify how AngularJS is integrated in a rails  application.

As time goes on generators for angular controllers and services (rails-models) will be added, as well as some view helpers and directives.  For the time being however the the gem is rather simple.

It relies on two pieces of slight magic and a directive.

* a Rails service that holds all your rails variables

* put your angular views in app/views/angular_app.  this solution is discussed in a handfull of places including [here](http://stackoverflow.com/questions/12116476/rails-static-html-template-files-in-the-asset-pipeline-and-caching-in-developmen).

> ```
scope :angular_app do
  get ':path.html' => 'ng_on_rails#template', constraints: { path: /.+/ }
end 
```
* a Render directive that mimics the rails render




