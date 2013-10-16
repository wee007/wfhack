((app) ->
  app.controller 'ActiveCategoryNavController', ['$scope', 'ProductSearch', ( $scope, ProductSearch ) ->
    $scope.$on '$locationChangeSuccess', (scope, current, next) ->
      $scope.activeNavigationItem = ProductSearch.params().super_cat
  ]
) angular.module("Westfield")
