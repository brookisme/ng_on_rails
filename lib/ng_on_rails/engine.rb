require "ng_on_rails/config_manager"

require 'angularjs-rails'
require 'angular_rails_csrf'

module NgOnRails
  class Engine < ::Rails::Engine    
    initializer 'ng_on_rails.load_static_assets' do |app|
      NgOnRails.config = ConfigManager.load_config 
      app.middleware.use ::ActionDispatch::Static, "#{root}/app"
    end

    initializer "ng_on_rails.view_helpers" do
      ActionView::Base.send :include, NgOnRailsHelper
    end
  end
end