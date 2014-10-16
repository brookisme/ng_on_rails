require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class LayoutGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates NgOnRails-style AngularJS layout"
    
    # arguments
    argument :full_model_name, type: :string, required: false, desc: "model name"    
    class_option :app_controller, type: :boolean, required: false, default: true, desc: "create app_controller"
    class_option :build, type: :boolean, required: false, default: true, desc: "BUILD as ng_data default"
    class_option :layout_name, type: :string, required: false, default: "application", desc: "name of layout. defaults to 'application', creating the file application.html.<format>"

    def copy_layout
      option_template "#{LayoutGenerator.source_root}/#{options[:format]}/layout_template.html.#{options[:format]}.erb", 
        "app/views/layouts/#{module_path}#{options[:layout_name]}.html.#{options[:format]}",
        "layout file"  
    end

    def copy_app_controller
      if options[:app_controller]
        option_copy_file "#{LayoutGenerator.source_root}/app_controller_template.js.coffee", 
          "app/assets/javascripts/#{module_path}angular_app/controllers/app_controller.js.coffee",
          "app controller"
      end
    end

  private 

  end
end