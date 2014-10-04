### TestApp for [NgOnRails](https://github.com/brookisme/ng_on_rails/)

This TestApp serves as an example of how NgOnRails should be used.  Some details:

* The DB is Postgres
* The (Angular) Views use Slim
* The JS uses CoffeeScript (except for _rails_service.js.erb -- where I need access to Rails)
* Much of app/views/angular_app & app/assests/javascripts/angular_app has been cut and pasted in from a different project and the models have been generated with Rails scaffolding.  This leads to a few oddities:
  * The full scaffolding has been left in but the Angular views are contained solely withing the docs-index and doc-show pages.
  * Though there is limited CSS but I use both bootstrap and font-awesome 
* Put Angular controllers/directives/... in a folder "angular\_app" in the assets directory.  Similarly, as discussed above, the angular views(partials) are placed in a folder "angular\_app" in the views directory

File Structure:
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