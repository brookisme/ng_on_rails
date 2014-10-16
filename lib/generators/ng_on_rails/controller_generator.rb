require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class ControllerGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates NgOnRails-style AngularJS Controller"
    argument :full_model_name, type: :string, required: false, desc: "model name"    

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_controller
      if model_name.blank?
        option_copy_file "#{ControllerGenerator.source_root}/app_controller_template.js.coffee", 
          "app/assets/javascripts/#{module_path}angular_app/controllers/app_controller.js.coffee",
          "app controller"
      else
        option_copy_file "#{ControllerGenerator.source_root}/controller_template.js.erb", 
          "app/assets/javascripts/#{module_path}angular_app/controllers/#{plural_name}_controller.js.coffee",
          "#{plural_name} controller",
          true
      end
    end

  private

  end
end