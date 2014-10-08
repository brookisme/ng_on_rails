require 'rails/generators'
module NgOnRails
  class LayoutGenerator < Rails::Generators::Base
    desc "Creates NgOnRails-style AngularJS layout"
    
    # arguments
    class_option :format, type: :string, required: false, default: "slim", desc: "*** FOR NOW ONLY OFFERS SLIM*** templating engine. defaults to slim. slim, haml, erb"
    class_option :overwrite, type: :boolean, required: false, default: false, desc: "overwrite file if it exist"
    class_option :app_controller, type: :boolean, required: false, default: true, desc: "create app_controller"
    class_option :layout_name, type: :string, required: false, default: "application", desc: "name of layout. defaults to 'application', creating the file application.html.<format>"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_layout
      option_copy_file "#{LayoutGenerator.source_root}/#{options[:format]}/layout_template.html.#{options[:format]}", 
        "app/views/layouts/#{options[:layout_name]}.html.#{options[:format]}",
        "layout file"  
    end

    def copy_app_controller
      if options[:app_controller]
        option_copy_file "#{LayoutGenerator.source_root}/app_controller_template.js.coffee", 
          "app/assets/javascripts/angular_app/controllers/app_controller.js.coffee",
          "app controller"
      end
    end

  private 

    def option_copy_file from_path, to_path, file_type
      if File.exist?(to_path)
        if options[:overwrite]
          remove_file(to_path)
          copy_file from_path, to_path
        else
          puts "ERROR: Failed to generate #{file_type || 'file'}. #{to_path} exists. Delete file or use the --overwrite=true option when generating the layout"
        end
      else
        copy_file from_path, to_path
      end 
    end
  end
end