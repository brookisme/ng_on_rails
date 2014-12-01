NgOnRailsApp.controller 'DataController', [
  '$scope',($scope) ->
    #
    # CONTROLLER SETUP
    #
    ctrl = this
      
    init = ()->
      ctrl.parent = $scope.data
    init()

    #
    # END
    #
    return
  ]