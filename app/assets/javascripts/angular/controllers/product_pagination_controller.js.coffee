((app) ->
  app.controller "ProductPaginationController", ["$scope", "Products", "ProductSearch", ($scope, Products, ProductSearch) ->

    total = ->
      parseInt ProductSearch.count

    perPage = ->
      parseInt ProductSearch.params().rows

    $scope.totalPages = ->
      Math.ceil(total() / perPage())

    $scope.page = ->
      parseInt ProductSearch.params().page

    $scope.has_prev = ->
      $scope.page() > 1

    $scope.has_next = ->
      perPage() * $scope.page() < total()

    $scope.next = ->
      Products.loading = true
      ProductSearch.setParam 'page', ($scope.page() + 1)
      ProductSearch.getSearch()

    $scope.prev = ->
      Products.loading = true
      ProductSearch.setParam 'page', ($scope.page() - 1)
      ProductSearch.getSearch()

  ]
) angular.module("Westfield")