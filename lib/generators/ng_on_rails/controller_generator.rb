require 'rails/generators'
module NgOnRails
  class ControllerGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS Controller"
    argument :model_name, type: :string, required: false, desc: "model name"    
    class_option :belongs_to, type: :array, required: false, default: [], desc: "list of models it belongs_to"
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_controller
      if model_name.blank?
        option_copy_file "#{ControllerGenerator.source_root}/app_controller_template.js.coffee", 
          "app/assets/javascripts/angular_app/controllers/app_controller.js.coffee",
          "app controller"
      else
        option_copy_file "#{ControllerGenerator.source_root}/controller_template.js.erb", 
          "app/assets/javascripts/angular_app/controllers/#{plural_name}_controller.js.coffee",
          "#{plural_name} controller",
          true
      end
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

    def option_copy_file from_path, to_path, file_type, template=false
      if File.exist?(to_path)
        if options[:overwrite]
          remove_file(to_path)
          if template
            template from_path, to_path
          else
            copy_file from_path, to_path
          end
        else
          puts "ERROR: Failed to generate #{file_type || 'file'}. #{to_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        if template
          template from_path, to_path
        else
          copy_file from_path, to_path
        end      
      end 
    end

    #
    # View Helpers
    #

    def path_to_index_page
      Rails.application.routes.url_helpers.send("#{plural_name}_path")
    end
    
    def belongs_to_array
      if options[:belongs_to].blank?
        []
      else
        options[:belongs_to].map do |a| 
          a.underscore.gsub(" ","")+"_id"
        end
      end
    end
    def belongs_to_comma
      unless options[:belongs_to].blank?
        ","
      end
    end
    def belongs_to_parameters
      unless options[:belongs_to].blank?
        belongs_to_array.join(",")
      end
    end
  end
end