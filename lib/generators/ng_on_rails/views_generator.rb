require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class ViewsGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates NgOnRails-style AngularJS Views"
    
    # arguments
    argument :full_model_name, type: :string, required: true, desc: "required"
    class_option :styles, type: :boolean, required: false, default: true, desc: "add ng_on_rails_styles.css"

    def generate_views
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/index.html.erb", 
        "app/views/#{module_path}angular_app/#{plural_name}/index.html.#{options[:format]}",
        "index view"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/show.html.erb", 
        "app/views/#{module_path}angular_app/#{plural_name}/show.html.#{options[:format]}",
        "show view"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_show.html.erb", 
        "app/views/#{module_path}angular_app/#{plural_name}/_show.html.#{options[:format]}",
        "_show partial"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_form.html.erb", 
        "app/views/#{module_path}angular_app/#{plural_name}/_form.html.#{options[:format]}",
        "_form partial"
      option_template "#{ViewsGenerator.source_root}/views/#{options[:format]}/_model.html.erb", 
        "app/views/#{module_path}angular_app/#{plural_name}/_#{resource_name}.html.#{options[:format]}",
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
        generate "ng_on_rails:jbuilder #{full_model_name} #{jbuilder_attributes} --overwrite=#{options[:overwrite]}"
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

    def is_plural? string
      string.pluralize == string
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

    def relationship_url relationship
      "#{relationship.pluralize}/#{is_plural?(relationship) ? 'index' : 'show' }"
    end

    #
    #  TEMPLATES
    #

    def index_path
      @index_path ||= "app/views/#{module_path}#{plural_name}/index.html.#{options[:format]}"
    end

    def show_path
      @show_path ||= "app/views/#{module_path}#{plural_name}/show.html.#{options[:format]}"
    end

    def jbuilder_attributes
      (
        options[:properties].map{ |prop| "#{prop.split("{")[0].split(":")[0]}" } | 
        options[:belongs_to].map{ |model| "#{model.underscore}_id" } | 
        options[:relationships].map{ |relationship| relationship.underscore }
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