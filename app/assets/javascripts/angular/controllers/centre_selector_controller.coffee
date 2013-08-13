((app) ->
  app.controller 'CentreSelectorController', ['$scope', 'Search', ( $scope, Search ) ->
    $scope.selectCentre = ->
      # Selected centre could be a list,
      # so we'll always treat it as such
      centres = $scope.selectedCentre.split( ',' )

      Search.setParam "centre", centres
      Search.getSearch()

  ]
) angular.module("Westfield")