require File.join(File.dirname(__FILE__), 'ng_on_rails_generator')
module NgOnRails
  class ScaffoldGenerator < NgOnRails::NgOnRailsGenerator
    desc "Creates NgOnRails-style AngularJS Views"
    
    argument :model_name, type: :string, required: true, desc: "required"
    class_option :layout, type: :boolean, required: false, default: true, desc: "create layout"
    # layout generator
    class_option :app_controller, type: :boolean, required: false, default: true, desc: "create app_controller"
    class_option :build, type: :boolean, required: false, default: true, desc: "BUILD as ng_data default"
    class_option :layout_name, type: :string, required: false, default: "application", desc: "name of layout. defaults to 'application', creating the file application.html.<format>"
    # views generator
    class_option :styles, type: :boolean, required: false, default: true, desc: "add ng_on_rails_styles.css"

    def generate_layout
      if options[:layout]
        generate "ng_on_rails:layout #{options_string}"
      end
    end
    def generate_resource
      generate "ng_on_rails:resource #{model_name} #{options_string}"
    end
    def generate_controller
      generate "ng_on_rails:controller #{model_name} #{options_string}"
    end
    def generate_views
      generate "ng_on_rails:views #{model_name} #{options_string}"
    end
    
  private

    def options_string
      if @options_string.nil?
        @options_string = ""
        options.each do |option|
          unless option[1].blank?
            @options_string += " --#{option[0]}"
            if option[1].is_a?(Array)
              option[1].each do |opt_value|
                @options_string += " #{opt_value}"
              end
            else
              @options_string += " #{option[1]}"
            end
          end
        end
      end
      @options_string
    end
  end
end