((app) ->
  app.controller 'ActiveCategoryNavController', ['$scope', 'ProductSearch', ( $scope, ProductSearch ) ->
    $scope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $scope.activeNavigationItem = toParams.super_cat
  ]
) angular.module("Westfield")
