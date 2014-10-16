class NgOnRailsController < ApplicationController
  def template
    @path = params[:path]
    render template: "/#{NgOnRails.engine_path}angular_app/" + @path, layout: nil
  end
end
