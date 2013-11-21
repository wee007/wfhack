((app) ->
  app.controller 'ActiveCategoryNavController', ['$scope', ( $scope ) ->
    $scope.$on '$routeChangeSuccess', (event, to, from) ->
      $scope.activeNavigationItem = to.params.super_cat
  ]
) angular.module("Westfield")
