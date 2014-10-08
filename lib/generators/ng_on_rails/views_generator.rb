require 'rails/generators'
module NgOnRails
  class ViewsGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS Views"
    
    # arguments
    argument :model_name, type: :string, required: true, desc: "required"
    class_option :properties, type: :array, required: false, default: [], desc: "list of properties"
    class_option :relationships, type: :array, required: false, default: [], desc: "list of relationships. determines has_many/one from singular/plural name"
    class_option :format, type: :string, required: false, default: "slim", desc: "*** FOR NOW ONLY OFFERS SLIM*** templating engine. defaults to slim. slim, haml, erb"
    class_option :styles, type: :boolean, required: false, default: true, desc: "add ng_on_rails_styles.css"
    class_option :belongs_to, type: :array, required: false, default: [], desc: "list of models it belongs_to"
    class_option :render_views, type: :boolean, required: false, default: true, desc: "Insert render_view directives into rails-views"
    class_option :jbuilder, type: :boolean, required: false, default: false, desc: "Create jbuilder files the rails-views directory for json"
    class_option :rails_views, type: :boolean, required: false, default: false, desc: "Insert both render_views and jbuilder files in rails-views"
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_views
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/index.html.erb", 
        "app/views/angular_app/#{plural_name}/index.html.#{options[:format]}",
        "index view"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/show.html.erb", 
        "app/views/angular_app/#{plural_name}/show.html.#{options[:format]}",
        "show view"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_show.html.erb", 
        "app/views/angular_app/#{plural_name}/_show.html.#{options[:format]}",
        "_show partial"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_form.html.erb", 
        "app/views/angular_app/#{plural_name}/_form.html.#{options[:format]}",
        "_form partial"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_model.html.erb", 
        "app/views/angular_app/#{plural_name}/_#{resource_name}.html.#{options[:format]}",
        "_#{resource_name} partial"
    end

    def create_render_views_files
      if options[:render_views] || options[:rails_views]
        unless File.exist?(index_path)
          puts "File[ #{index_path} ] does not exist. creating file"
          create_file index_path, '/ File created with NgOnRails view generator'
        end

        unless File.exist?(show_path)
          puts "File[ #{show_path} ] does not exist. creating file"
          create_file show_path, '/ File created with NgOnRails view generator'
        end
      end
    end

    def create_jbuilder_files
      if options[:render_views] || options[:rails_views]
        unless File.exist?(index_path)
          puts "File[ #{index_path} ] does not exist. creating file"
          create_file index_path, '/ File created with NgOnRails view generator'
        end

        unless File.exist?(show_path)
          puts "File[ #{show_path} ] does not exist. creating file"
          create_file show_path, '/ File created with NgOnRails view generator'
        end
      end
    end

    def insert_render_views
      if options[:render_views] || options[:rails_views]
        append_file index_path, render_index_view_template
        append_file show_path, render_show_view_template
      end
    end

    def generate_jbuilder_files
      if options[:jbuilder] || options[:rails_views]
        generate "ng_on_rails:jbuilder #{class_name} #{jbuilder_attributes} --overwrite=#{options[:overwrite]}"
      end
    end

    def add_css
      if options[:styles]
        styles_path = "app/assets/stylesheets/ng_on_rails_styles.css"  
        unless File.exist?(styles_path)
          puts "Adding ng_on_rails_styles.css -- <better with bootstrap and fontAwesome!>"
          copy_file "#{ViewsGenerator.source_root}/styles_template.css", styles_path    
        end
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
    
    def args arg_string
      parts = arg_string.split("{")
      if (parts.length > 1)
        if !!parts[1].match(/required/)
          required = true
        else
          required = false
        end 
        if !!parts[1].match(/skip_form/)
          skip_form = true
        else
          skip_form = false
        end
        if !!parts[1].match(/skip_index/)
          skip_index = true
        else
          skip_index = false
        end 
        if !!parts[1].match(/link/)
          link = true
        else
          link = false
        end 
      end 
      args = parts[0].split(":")
      {
        name: args[0],
        type: args[1],
        required: required,
        skip_form: skip_form,
        skip_index: skip_index,
        link: link
      }
    end

    #
    #  VIEW HELPERS
    #

    def path_to_index_page
      Rails.application.routes.url_helpers.send("#{plural_name}_path")
    end

    def type_to_class type_string
      unless type_string.blank?
        ".#{type_string}"
      end
    end

    def required_string property_hash
       if property_hash[:required] 
        required_string = "required=\"true\""
      end
    end

    def is_plural? string
      string.pluralize == string
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
    #  TEMPLATES
    #

    def index_path
      @index_path ||= "app/views/#{plural_name}/index.html.#{options[:format]}"
    end

    def show_path
      @show_path ||= "app/views/#{plural_name}/show.html.#{options[:format]}"
    end

    def jbuilder_attributes
      (
        options[:properties].map{ |prop| "#{prop.split("{")[0].split(":")[0]}" } | 
        options[:belongs_to].map{ |model| "#{model}_id" } | 
        options[:relationships]
      ).join(" ")
    end

    def render_index_view_template
      if options[:format]=="erb"
        puts "ERB format not yet added"
      elsif options[:format]=="haml"
        puts "HAML format not yet added"
      else
"

/ 
/ Inserted by NgOnRails view generator.
/ 
div ng-init=\"#{plural_name}=ctrl.rails.#{plural_name}\" render_view=\"true\" url=\"#{plural_name}/index\"
/
/
/

"
      end
    end

    def render_show_view_template
      if options[:format]=="erb"
        puts "ERB format not yet added"
      elsif options[:format]=="haml"
        puts "HAML format not yet added"
      else
"

/ 
/ Inserted by NgOnRails view generator.
/ 
div ng-init=\"#{resource_name}=ctrl.rails.#{resource_name}\" render_view=\"true\" url=\"#{plural_name}/show\"
/
/
/

"
      end
    end
  end
end