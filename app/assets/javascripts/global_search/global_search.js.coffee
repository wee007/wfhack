@app ||= angular.module( 'Westfield', ['ngMobile', 'ngSanitize'] );

@app.controller "GlobalSearchCtrl", ($scope, SuggestionsBuilder, GlobalSearch) ->
  $scope.searchQuery = null
  $scope.searchResults = {}

  $scope.$watch 'searchQuery', ->
    if $scope.searchQuery && $scope.searchQuery != ""
      $scope.search()
    else
      $scope.searchResults = {}
      $scope.suggestions = self.didYouMean()

  @didYouMean = ->
    SuggestionsBuilder.didYouMean($scope.searchResults['results'])

  self = this

  $scope.search = ->
    url = "/api/search/master/search.json"
    GlobalSearch.onChange (data)->
      $scope.searchResults = data
      $scope.suggestions = self.didYouMean()
    GlobalSearch.get url, {term: $scope.searchQuery}
