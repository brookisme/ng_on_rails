class NgOnRailsController < ApplicationController
  def template
    @path = params[:path]
    render template: '/angular_app/' + @path, layout: nil
  end
end
