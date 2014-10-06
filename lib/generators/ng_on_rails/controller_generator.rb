require 'rails/generators'
module NgOnRails
  class ControllerGenerator < Rails::Generators::NamedBase
    desc "Creates NgOnRails-style AngularJS Controller"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_layout
      template "#{ControllerGenerator.source_root}/controller_template.js.erb", "app/assets/javascripts/angular_app/controllers/#{plural_name}_controller.js.coffee"
    end
  end
end