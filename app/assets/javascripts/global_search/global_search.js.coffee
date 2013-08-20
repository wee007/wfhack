@app ||= angular.module( 'Westfield', ['ngMobile', 'ngSanitize'] )

@app.controller "GlobalSearchCtrl", ['$scope', 'SuggestionsBuilder', 'GlobalSearch', ($scope, SuggestionsBuilder, GlobalSearch) ->
  $scope.searchQuery = null
  $scope.searchResults = {}

  $scope.$watch 'searchQuery', =>
    if $scope.searchQuery && $scope.searchQuery != ""
      $scope.search()
    else
      $scope.searchResults = {}
      $scope.suggestions = @didYouMean()

  @didYouMean = ->
    SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.searchResults['results'])

  GlobalSearch.onChange (data)=>
    $scope.searchResults = data
    $scope.suggestions = @didYouMean()

  $scope.search = ->
    url = "/api/search/master/search.json"
    GlobalSearch.get url, {term: $scope.searchQuery}
]
