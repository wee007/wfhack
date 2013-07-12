( function ( app ) {
  app.controller( 'BrowseController', function ( $window, $scope, $filter, $location, $routeParams, ParamCleaner, Search, Products ) {
    $scope.search = Search;
    $scope.products = Products;

    // Multi-facet search fields
    $scope.categories = [];
    $scope.retailers = [];
    $scope.brands = [];

    // Multi-value facets must be sent back using the original
    // name of the model. eg. 'brands' should become 'brands'
    var searchParamMap = {
      'categories': 'type',
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

    updateFilters = function () {
      Search.getSearch(function () {
        cleanParams = ParamCleaner.build( Search.params() );
        $location.search( cleanParams );
      });
    };

    updateProducts = function () {
      Products.get( $location.path(), Search.params(), function () {
        setTimeout(function () {
          $window.initPlugin.isotope();
        }, 250);
      });
    };

    updateSearch = function () {
      updateProducts();
      updateFilters();
    };

    // Adds params to search from URL string
    executeInitialSearch = function () {
      useRouteParams();
      updateFilters();
    }(); // Self init

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
      selectedValues = $filter('filter')($scope.search[attributeName].values, { selected: true });

      values = [];
      angular.forEach( selectedValues, function ( selectedValue ) {
        values.push( selectedValue.code );
      });

      if ( searchParamMap[attributeName] !== undefined ) { attributeName = searchParamMap[attributeName]; }
      Search.setParam( attributeName, values );
      updateSearch();
    };

    $scope.clearFilters = function () {
      newParams = {};
      if ( $routeParams.centre ) { newParams.centre = $routeParams.centre; }
      Search.resetParams( newParams );
      updateSearch();
    };

    $scope.filterCategory = function ( categoryType, categoryCode ) {
      Search.setParam( categoryType, categoryCode );
      updateSearch();
    };

    $scope.rangeFilter = function ( paramName ) {
      min = $scope.search[paramName].range_start;
      max = $scope.search[paramName].range_end;
      paramValue = min + '-' + max;

      Search.setParam( paramName, paramValue );
    };
  });
}( angular.module( 'Westfield' ) ));