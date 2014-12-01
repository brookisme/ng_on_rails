#
# NgOnRails: Render Directives
#

set_data = (scope,el,attrs)->
  scope.data ||= {} 
  if attrs['includeParentData'] != "false"
    for k, v of scope.data.parent
      scope.data[k] = v
  scope.data.parent = null
  if !!attrs['data']
    if !!scope.data
      data_array = attrs['data'].split(";")
      for data in data_array
        key_val_arr = data.split("=")
        scope.data[key_val_arr[0].trim()] = scope.$eval(key_val_arr[1].trim())

NgOnRailsApp.directive "renderView", ->
  restrict: "AE",
  transclude: true,
  link: set_data
  template: (el,attrs)->
    format = attrs.format || "html"
    '<div ng_include="\'/angular_app/'+attrs.url+'.'+format+'\'"></div>'

NgOnRailsApp.directive "render", ->
  restrict: "AE",
  transclude: true,
  link: set_data
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