$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ng_on_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ng_on_rails"
  s.version     = NgOnRails::VERSION
  s.authors     = ["Brookie Williams"]
  s.email       = ["brookwilliams@laborvoices.com"]
  s.homepage    = "http://www.laborvoices.com"
  s.summary     = "A Rails inspired framework for using AngularJS with Rails"
  s.description = "A Rails inspired framework for using AngularJS with Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"
end
