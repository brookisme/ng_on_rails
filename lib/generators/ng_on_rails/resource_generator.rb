require 'rails/generators'
module NgOnRails
  class ResourceGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS Resource Service"
    argument :model_name, type: :string, required: true, desc: "model name"    
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_layout
      option_template "#{ResourceGenerator.source_root}/resource_template.js.erb", 
        "app/assets/javascripts/angular_app/services/#{resource_name}.js.coffee",
        "#{resource_name} resource"
    end
  
  private

    def class_name
      @class_name ||= model_name.classify
    end

    def resource_name
      @resource_name ||= class_name.underscore
    end
    
    def plural_name
      @plural_name ||= resource_name.pluralize
    end

    def option_template from_path, to_path, file_type
      if File.exist?(to_path)
        if options[:overwrite]
          remove_file(to_path)
          template from_path, to_path
        else
          puts "ERROR: Failed to generate #{file_type || 'file'}. #{to_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        template from_path, to_path
      end 
    end
  end
end