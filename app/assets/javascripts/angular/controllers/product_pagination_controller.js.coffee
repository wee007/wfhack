((app) ->
  app.controller "ProductPaginationController", ["$scope", "Products", "ProductSearch", ($scope, Products, ProductSearch) ->

    page = ->
      parseInt ProductSearch.params().page

    total = ->
      parseInt ProductSearch.count

    rows = ->
      parseInt ProductSearch.params().rows

    $scope.next = ->
      Products.loading = true
      ProductSearch.setParam 'page', (page() + 1)
      ProductSearch.getSearch()

    $scope.prev = ->
      Products.loading = true
      ProductSearch.setParam 'page', (page() - 1)
      ProductSearch.getSearch()

    $scope.has_prev = ->
      page() > 1

    $scope.has_next = ->
      rows() * page() < total()

  ]
) angular.module("Westfield")