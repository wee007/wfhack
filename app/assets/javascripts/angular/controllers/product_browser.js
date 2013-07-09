( function ( app ) {
  app.controller( 'BrowseController', function ( $scope, $filter, $location, $routeParams, ParamCleaner, Search ) {
    $scope.search = Search;
    $scope.productsDidLoad = false;

    // Multi-facet search fields
    $scope.retailers = [];
    $scope.brands = [];

    // Multi-value facets must be sent back using the original
    // name of the model. eg. 'brands' should become 'brands'
    var searchParamMap = {
      'selectedSubCategory': 'sub_category',
      'retailers': 'retailer',
      'brands': 'brand'
    };

    useRouteParams = function () {
      params = ParamCleaner.deserialize( $routeParams );

      angular.forEach( params, function ( param, key ) {
        // Add params to the controller
        // not all params will be used by the view
        // but we'll map them anyway.
        $scope[key] = param;
        Search.setParam( key, param );
      });
    };

    // Adds params to search from URL string
    executeInitialSearch = function () {
      useRouteParams();

      $scope.productsDidLoad = false;
      Search.getSearch(function () {
        $scope.productsDidLoad = true;
      });
    };

    executeInitialSearch(); // Init

    updateSearch = function () {
      $scope.productsDidLoad = false;

      cleanParams = ParamCleaner.build( Search.params );
      $location.search( cleanParams );

      Search.getSearch(function () {
        $scope.productsDidLoad = true;
      });
    };

    $scope.removeSelectedFilter = function ( paramName, paramValue ) {
      Search.removeParam( paramName, paramValue );
      updateSearch();
    };

    $scope.filterSearch = function ( modelName ) {
      Search.setParam( modelName, $scope[modelName] );
      updateSearch();
    };

    // multi-facet filter search
    $scope.mvFilterSearch = function ( attributeName ) {
      selectedValues = $filter('filter')($scope.search[attributeName], { selected: true });

      values = [];
      angular.forEach( selectedValues, function ( selectedValue ) {
        values.push( selectedValue.code );
      });

      if ( searchParamMap[attributeName] !== undefined ) { attributeName = searchParamMap[attributeName]; }
      Search.setParam( attributeName, values );
      updateSearch();
    };

    $scope.clearFilters = function () {
      // Reset Search params to default
      Search.resetParams();

      // Remove query strings
      $location.search("");

      // Start over
      executeInitialSearch();
    };

    $scope.rangeFilter = function ( paramName ) {
      min = $scope.search[paramName].range_start;
      max = $scope.search[paramName].range_end;
      paramValue = min + '-' + max;

      Search.setParam( paramName, paramValue );
    }
  });
}( angular.module( 'Westfield' ) ));