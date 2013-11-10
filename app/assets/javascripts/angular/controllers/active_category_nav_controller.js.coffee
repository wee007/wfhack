((app) ->
  app.controller 'ActiveCategoryNavController', ['$scope', 'ProductSearch', ( $scope, ProductSearch ) ->
    $scope.$on '$routeChangeSuccess', (event, to, from) ->
      $scope.activeNavigationItem = to.params.super_cat
  ]
) angular.module("Westfield")
