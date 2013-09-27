((app) ->
  app.controller "ProductPaginationController", ["$scope", "$window", "Products", "ProductSearch", ($scope, $window, Products, ProductSearch) ->

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
      $window.scrollTo(0, 0)
      Products.loading = true
      ProductSearch.setParam 'page', ($scope.page() + 1)
      ProductSearch.getSearch()

    $scope.prev = ->
      $window.scrollTo(0, 0)
      Products.loading = true
      ProductSearch.setParam 'page', ($scope.page() - 1)
      ProductSearch.getSearch()

  ]
) angular.module("Westfield")