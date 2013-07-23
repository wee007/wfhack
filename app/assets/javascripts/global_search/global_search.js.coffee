app = angular.module("Westfield", [])

app.controller "GlobalSearchCtrl", ($scope, SuggestionsBuilder, Search) ->
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
    url = "/api/search/master/search.json"
    Search.onChange (data)->
      $scope.searchResults = data
      $scope.suggestions = self.didYouMean()
    Search.get url, {term: $scope.searchQuery}
