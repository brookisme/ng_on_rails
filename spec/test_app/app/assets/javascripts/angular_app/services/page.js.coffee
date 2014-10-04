NgOnRailsApp.factory "Page", ($resource) ->
  PageResource = $resource "/pages/:id.json", {id: "@id"}, {
    update:{method: "PUT"}
  }
  class Page extends PageResource