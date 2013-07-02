app = angular.module("Westfield", [])

app.controller "GlobalSearchCtrl", ($scope) ->
  $scope.searchQuery = null
  $scope.searchResults = {}

  $scope.$watch 'searchQuery', ->
    if $scope.searchQuery && $scope.searchQuery != ""
      $scope.search()
    else
      $scope.searchResults = {}

  $scope.resultCombinations = ->
    return [] unless $scope.searchResults['results']
    results = $scope.searchResults['results']
    combinations = []
    angular.forEach(['longest','single'], (match_type)->
      combo = {}
      query = ''
      angular.forEach(results[match_type], (match)->
        if match[1]
          combo[match[1][0]['data']['param_name']] ||= []
          combo[match[1][0]['data']['param_name']].push match[1][0]['data']['param_value']
        else
          query = "#{query} #{match[0]}".trim
      )
      if not query is ''
        combo['search_query'] = query
      if combo != {}
        combinations.push combo
    )
    combinations

  $scope.resultUrlQueries = ->
    # Angular has no map function =(
    queries = []
    angular.forEach($scope.resultCombinations(), (combo)->
      search_query = combo['search_query']
      delete combo['search_query']
      if search_query
        query = "?search_query=#{query}"
      else
        query = '?'
      console.debug combo
      angular.forEach combo, (values,key)->
        angular.forEach values, (value)->
          query += "&#{key}[]=#{value}"
      queries.push query
    )
    queries

  $scope.search = ->
    url = "/api/search/master/search.json" +
      "?term=" + $scope.searchQuery
    $.ajax
      type: "GET"
      dataType: "json"
      contentType: "application/json; charset=utf-8"
      url: url
      success: (data) ->
        $scope.$apply ->
          $scope.searchResults = data

