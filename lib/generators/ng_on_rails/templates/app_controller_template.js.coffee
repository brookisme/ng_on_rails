NgOnRailsApp.controller 'AppController', [
  '$scope','Rails',
  ($scope,Rails) ->
    # setup
    ctrl = this
    ctrl.rails = Rails
    return
  ]