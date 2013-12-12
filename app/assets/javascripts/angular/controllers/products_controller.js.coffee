((app) ->
  app.controller "ProductsController", ["$scope", "Products", "ProductSearch", ($scope, Products, ProductSearch) ->
    $scope.products = Products

    $scope.$on '$routeChangeSuccess', (event, to, from) ->
      unless from == undefined or from == to
        Products.get document.location.pathname, ProductSearch.params()
  ]
) angular.module("Westfield")