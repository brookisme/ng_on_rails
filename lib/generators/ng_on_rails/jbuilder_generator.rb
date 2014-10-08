require 'rails/generators'
module NgOnRails
  class JbuilderGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS Resource Service"
    argument :model_name, type: :string, required: true, desc: "model name"    
    argument :attributes, type: :array, required: false, desc: "list of attributes in json"    
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_index 
      option_create "app/views/#{plural_name}/index.json.jbuilder",
        "json.partial! '#{plural_name}/#{plural_name}.json', #{plural_name}: @#{plural_name}",
        "index jbuilder"
    end
    def generate_show
      option_create "app/views/#{plural_name}/show.json.jbuilder",
        "json.partial! '#{plural_name}/#{resource_name}.json', #{resource_name}: @#{resource_name}",
        "index jbuilder"    
    end
    def generate_models
      option_create "app/views/#{plural_name}/_#{plural_name}.json.jbuilder",
        "json.array! #{plural_name}, partial: '#{plural_name}/#{resource_name}.json', as: :#{resource_name}",
        "models jbuilder"
    end
    def generate_model
      option_create "app/views/#{plural_name}/_#{resource_name}.json.jbuilder",
      "json.extract! #{resource_name} #{attributes_string}",      
      "model jbuilder"    
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

    def option_create file_path, content, file_type
      if File.exist?(file_path)
        if options[:overwrite]
          remove_file(file_path)
          create_file file_path, content
        else
          puts "ERROR: Failed to generate #{file_type || 'file'}. #{file_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        create_file file_path, content
      end 
    end

    def attributes_string
      unless attributes.blank?
        attributes.map{ |attribute|
          ", :#{attribute}"
        }.join("")
      end
    end
  end
end