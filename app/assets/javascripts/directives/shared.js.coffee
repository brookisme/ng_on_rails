#
# NgOnRails: Render Directives
#

NgOnRailsApp.directive "renderView", ->
  restrict: "AE",
  transclude: true,
  template: (el,attrs)->
    format = attrs.format || "html"
    '<div ng_include="\'/angular_app/'+attrs.url+'.'+format+'\'"></div>'

NgOnRailsApp.directive "render", ->
  restrict: "AE",
  transclude: true,
  template: (el,attrs)->
    format = attrs.format || "html"
    url_parts = attrs.url.split("/")
    if (url_parts[url_parts.length-1].trim()=="")
      url_parts.pop()
    last = url_parts.pop()
    url_parts.push("_"+last)
    path = url_parts.join("/")
    '<div ng_include="\'/angular_app/'+path+'.'+format+'\'"></div>'


#
# NgOnRails: View Helper Directives
#

NgOnRailsApp.directive "confirm", ->
    link: (scope, el, attrs)->
      msg = attrs.confirm || "Are you sure?"
      el.bind 'click', ->
        scope.$eval(attrs.action) if window.confirm(msg)