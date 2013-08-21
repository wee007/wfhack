((app) ->
  app.controller "GlobalSearchCtrl", ['$scope', 'SuggestionsBuilder', 'GlobalSearch', ($scope, SuggestionsBuilder, GlobalSearch) ->
    $scope.search = GlobalSearch
    $scope.searchQuery = ""

    GlobalSearch.onChange ->
      $scope.suggestions = didYouMean()

    didYouMean = ->
      SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.search.results)

    $scope.$watch 'searchQuery', ->
      if $scope.searchQuery && $scope.searchQuery != ""
        GlobalSearch.get {term: $scope.searchQuery}
      else
        $scope.suggestions = didYouMean()
  ]
) angular.module("Westfield")