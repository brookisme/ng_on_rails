require 'rails/generators'
module NgOnRails
  class ControllerGenerator < Rails::Generators::NamedBase
    desc "Creates NgOnRails-style AngularJS Controller"
    class_option :belongs_to, type: :array, required: false, default: [], desc: "list of models it belongs_to"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_layout
      template "#{ControllerGenerator.source_root}/controller_template.js.erb", "app/assets/javascripts/angular_app/controllers/#{plural_name}_controller.js.coffee"
    end

  private

    def belongs_to_array
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
        belongs_to_array.join(",")
      end
    end
  end
end