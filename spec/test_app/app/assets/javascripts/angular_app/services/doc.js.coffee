NgOnRailsApp.factory "Doc", ($resource) ->
  DocResource = $resource "/survey_link/surveys/:id.json", {id: "@id"}, {
    update:{method: "PUT"}
  }
  class Doc extends DocResource