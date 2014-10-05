NgOnRailsApp.factory 'Doc', ($resource) ->
  DocResource = $resource '/docs/:id.json', {id: '@id'}, {
    update:{method: "PUT"}
  }
  class Doc extends DocResource
    # place class and instance methods here