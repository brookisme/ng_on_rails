require 'rails/generators'
module NgOnRails
  class ResourceGenerator < Rails::Generators::NamedBase
    desc "Creates NgOnRails-style AngularJS Resource Service"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_layout
      template "#{ResourceGenerator.source_root}/resource_template.js.erb", "app/assets/javascripts/angular_app/services/#{file_name}.js.coffee"
    end
  end
end