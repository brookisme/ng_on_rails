require 'rails/generators'
module NgOnRails
  class ViewsGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS Views"
    
    # arguments
    argument :model_name, type: :string, required: true, desc: "required"
    class_option :properties, type: :array, required: false, default: [], desc: "list of properties"
    class_option :relationships, type: :array, required: false, default: [], desc: "list of relationships:formatype"
    class_option :format, type: :string, required: false, default: "slim", desc: "*** FOR NOW ONLY OFFERS SLIM*** templating engine. defaults to slim. slim, haml, erb"
    class_option :render_views, type: :boolean, required: false, default: true, desc: "Insert render_view directives into rails-views"
    class_option :styles, type: :boolean, required: false, default: true, desc: "add ng_on_rails_styles.css"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_layout
      template "#{ViewsGenerator.source_root}/views/#{options[:format]}/index.html.erb", "app/views/angular_app/#{plural_name}/index.html.#{options[:format]}"
      template "#{ViewsGenerator.source_root}/views/#{options[:format]}/show.html.erb", "app/views/angular_app/#{plural_name}/show.html.#{options[:format]}"
      template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_show.html.erb", "app/views/angular_app/#{plural_name}/_show.html.#{options[:format]}"
      template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_form.html.erb", "app/views/angular_app/#{plural_name}/_form.html.#{options[:format]}"
      template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_model.html.erb", "app/views/angular_app/#{plural_name}/_#{resource_name}.html.#{options[:format]}"
    end

    def create_render_views_files
      if insert_the_render_views?
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
      if insert_the_render_views?
        append_file index_path, render_index_view_template
        append_file show_path, render_show_view_template
      end
    end

    def add_css
      if options[:styles]
        styles_path = "app/assets/stylesheets/ng_on_rails_styles.css"  
        unless File.exist?(styles_path)
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
    
    def args arg_string
      parts = arg_string.split("{")
      if (parts.length > 1) && !!parts[1].match(/required/)
        req = true
      else
        req = false
      end 
      args = parts[0].split(":")
      {
        name: args[0],
        type: args[1],
        required: req
      }
    end

    #
    #  VIEW HELPERS
    #

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

    def insert_the_render_views?
      !(options[:render_views].blank? || options[:render_views]=="false")
    end

    def is_plural? string
      string.pluralize == string
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