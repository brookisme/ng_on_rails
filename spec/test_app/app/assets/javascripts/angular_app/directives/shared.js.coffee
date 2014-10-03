NgOnRailsApp.directive "confirm", ->
    link: (scope, el, attrs)->
      msg = attrs.confirm || "Are you sure?"
      el.bind 'click', ->
        scope.$eval(attrs.action) if window.confirm(msg)


