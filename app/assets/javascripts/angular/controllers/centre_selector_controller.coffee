((app) ->
  app.controller 'CentreSelectorController', ['$scope', '$location', 'ProductSearch', 'ParamCleaner', ( $scope, $location, ProductSearch, ParamCleaner ) ->
    $scope.selectCentre = ->
      # Selected centre could be a list,
      # so we'll always treat it as such
      centres = $scope.selectedCentre.split( ',' )

      ProductSearch.resetParams({centre: centres})
      params = ProductSearch.params()
      queryStringParams = ParamCleaner.build(params)

      $location.search(queryStringParams)

  ]
) angular.module("Westfield")