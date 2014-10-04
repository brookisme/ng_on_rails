NgOnRailsApp.factory "Doc", ($resource) ->
  DocResource = $resource "/docs/:id.json", {id: "@id"}, {
    update:{method: "PUT"}
  }
  class Doc extends DocResource