require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class JbuilderGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates jbuilder files in rails-views"
    argument :model_name, type: :string, required: true, desc: "model name"    
    argument :attributes, type: :array, required: false, desc: "list of attributes in json"    

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

    def attributes_string
      unless attributes.blank?
        attributes.map{ |attribute|
          ", :#{attribute}"
        }.join("")
      end
    end
  end
end