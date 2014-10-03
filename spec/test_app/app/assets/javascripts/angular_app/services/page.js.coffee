NgOnRailsApp.factory "Page", ($resource) ->
  PageResource = $resource "/survey_link/questions/:id.json", {id: "@id"}, {
    update:{method: "PUT"}
  }
  class Page extends PageResource