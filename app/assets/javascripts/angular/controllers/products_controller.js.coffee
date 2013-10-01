((app) ->
  app.controller "ProductsController", ["$scope", "Products", ($scope, Products) ->
    $scope.products = Products
  ]
) angular.module("Westfield")