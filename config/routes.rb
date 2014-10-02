Rails.application.routes.draw do
  # AngularJS Templates
  scope :angular_app do
    get ':path.html' => 'ng_on_rails#template', constraints: { path: /.+/ }
  end
end