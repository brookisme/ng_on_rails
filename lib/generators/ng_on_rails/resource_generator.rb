require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class ResourceGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates NgOnRails-style AngularJS Resource Service"
    argument :full_model_name, type: :string, required: true, desc: "model name"    

    def generate_layout
      option_template "#{ResourceGenerator.source_root}/resource_template.js.erb", 
        "app/assets/javascripts/#{module_path}angular_app/services/#{resource_name}.js.coffee",
        "#{resource_name} resource"
    end
  end
end