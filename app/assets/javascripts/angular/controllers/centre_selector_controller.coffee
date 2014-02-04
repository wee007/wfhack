((app) ->
  app.controller 'CentreSelectorController', ['$scope', '$location', 'ProductSearch', 'ParamCleaner', ( $scope, $location, ProductSearch, ParamCleaner ) ->
    $scope.selectCentre = ->
      # Selected centre could be a list,
      # so we'll always treat it as such
      centres = $scope.selectedCentre.split( ',' )

      if centres.length > 1 || centres[0] == 'all'
        ProductSearch.resetParams({centre: centres})
      else
        ProductSearch.resetParams()

      params = ProductSearch.params()
      queryStringParams = ParamCleaner.build(params)

      $location.search(queryStringParams)

  ]
) angular.module("Westfield")