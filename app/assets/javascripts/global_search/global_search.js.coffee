app = angular.module("Westfield", [])

app.controller "GlobalSearchCtrl", ($scope, SuggestionsBuilder) ->
  $scope.searchQuery = null
  $scope.searchResults = {}

  $scope.$watch 'searchQuery', ->
    if $scope.searchQuery && $scope.searchQuery != ""
      $scope.search()
    else
      $scope.searchResults = {}

  @didYouMean = ->
    SuggestionsBuilder.didYouMean($scope.searchResults['results'])

  self = this

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
          $scope.suggestions = self.didYouMean()

