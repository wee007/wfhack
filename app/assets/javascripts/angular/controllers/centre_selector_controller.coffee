((app) ->
  app.controller 'CentreSelectorController', ['$scope', 'ProductSearch', ( $scope, ProductSearch ) ->
    $scope.selectCentre = ->
      # Selected centre could be a list,
      # so we'll always treat it as such
      centres = $scope.selectedCentre.split( ',' )

      ProductSearch.setParam "centre", centres
      ProductSearch.getSearch()

  ]
) angular.module("Westfield")