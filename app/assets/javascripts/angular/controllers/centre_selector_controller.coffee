((app) ->
  app.controller 'CentreSelectorController', ['$scope', '$location', 'ProductSearch', 'ParamCleaner', ( $scope, $location, ProductSearch, ParamCleaner ) ->
    $scope.selectCentre = ->
      # Selected centre could be a list,
      # so we'll always treat it as such
      centres = $scope.selectedCentre.split( ',' )

      params = $.extend(ProductSearch.params(),{current_centre: $scope.currentCentre})
      if centres.length > 1 || centres[0] == 'all'
        params = $.extend(params,{centre: centres})
      else
        delete params.centre

      queryStringParams = ParamCleaner.build(params)

      $location.search(queryStringParams)
  ]
) angular.module("Westfield")