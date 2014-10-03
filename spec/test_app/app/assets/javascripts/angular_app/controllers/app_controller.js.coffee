NgOnRailsApp.controller 'AppController', ($scope,Bridge,Rails) ->
  # setup
  ctrl = this
  ctrl.bridge = Bridge
  ctrl.rails = Rails
  return