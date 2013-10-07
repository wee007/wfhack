((app) ->
  app.service "SuggestionsBuilder", ->

    @didYouMean = (searchString, searchResults)->
      results = []
      results.push dummyResult(searchString)
      results

    dummyResult = (searchString)->
      "description": "Products matching '#{searchString}'",
      "queryString": "?search_query=#{searchString}"

) angular.module("Westfield")
