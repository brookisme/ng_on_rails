require 'rails/generators'
require "ng_on_rails/config_manager"
module NgOnRails
  class NgOnRailsGenerator < Rails::Generators::Base
    desc "Shared options and methods for NgOnRails Generators"
    
    class_option :properties, type: :array, required: false, default: [], desc: "list of properties"
    class_option :relationships, type: :array, required: false, default: [], desc: "list of relationships. determines has_many/one from singular/plural name"
    class_option :format, type: :string, required: false, default: "slim", desc: "*** FOR NOW ONLY OFFERS SLIM*** templating engine. defaults to slim. slim, haml, erb"
    class_option :render_views, type: :boolean, required: false, default: true, desc: "Insert render_view directives into rails-views"
    class_option :jbuilder, type: :boolean, required: false, default: false, desc: "Create jbuilder files the rails-views directory for json"
    class_option :rails_views, type: :boolean, required: false, default: false, desc: "Insert both render_views and jbuilder files in rails-views"
    class_option :belongs_to, type: :array, required: false, default: [], desc: "list of models it belongs_to"
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def set_attributes
      if (defined?(full_model_name) && !full_model_name.nil?)
        if full_model_name.include?("::")
          parts = full_model_name.split("::")
          @module_name = parts[0]
          @model_name = parts[1]
        else
          @model_name = full_model_name
        end
      end
    end

  private

    def module_name
      return @module_name
    end

    def module_path
      unless module_name.nil?
        "#{module_name.underscore}/"
      end
    end

    def model_name
      @model_name
    end

    def class_name
      @class_name ||= @model_name.classify
    end

    def resource_name
      @resource_name ||= class_name.underscore
    end
    
    def plural_name
      @plural_name ||= resource_name.pluralize
    end

    #
    # Config
    #

    def config
      @config ||= ConfigManager.load_config
    end

    def mounted_path
      if @mounted_path.nil? && !config['mounted_path'].blank?
        @mounted_path = "#{config['mounted_path']}/"
      end
      @mounted_path
    end

    #
    # View Helpers
    #
    
    def path_to_index_page
      "/#{mounted_path}#{plural_name}"
    end

    def belongs_to_array
      if options[:belongs_to].blank?
        []
      else
        options[:belongs_to].map do |a| 
          a.underscore.gsub(" ","")+".id"
        end
      end
    end

    def belongs_to_parameter_array
      if options[:belongs_to].blank?
        []
      else
        options[:belongs_to].map do |a| 
          a.underscore.gsub(" ","")+"_id"
        end
      end
    end

    def belongs_to_parameters
      unless options[:belongs_to].blank?
        belongs_to_parameter_array.join(",")
      end
    end

    def belongs_to_comma
      unless options[:belongs_to].blank?
        ","
      end
    end

    def belongs_to_values
      unless options[:belongs_to].blank?
        belongs_to_array.join(",")
      end
    end

    #
    # Thor Helpers
    #

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
          puts "ERROR: Failed to #{template ? "template" : "copy"} #{file_type || 'file'}. #{to_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        if template
          template from_path, to_path
        else
          copy_file from_path, to_path
        end      
      end 
    end

    def option_template from_path, to_path, file_type
      option_copy_file from_path, to_path, file_type, true
    end

    def option_create file_path, content, file_type
      if File.exist?(file_path)
        if options[:overwrite]
          remove_file(file_path)
          create_file file_path, content
        else
          puts "ERROR: Failed to create #{file_type || 'file'}. #{file_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        create_file file_path, content
      end 
    end
  end
end