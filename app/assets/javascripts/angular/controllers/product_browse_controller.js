( function ( app ) {
  app.controller( 'ProductBrowseController', function ( $scope, $filter, $location, ParamCleaner, Search, Products ) {
    $scope.search = Search;

    // Multi-facet search fields
    $scope.categories = [];
    $scope.retailers = [];
    $scope.brands = [];
    $scope.colours = [];
    $scope.sizes = [];

    // Multi-value facets must be sent back using the original
    // name of the model. eg. 'brands' should become 'brands'
    var searchParamMap = {
      'categories': 'sub_category',
      'retailers': 'retailer',
      'brands': 'brand',
      'colours': 'colour',
      'sizes': 'size'
    };

    getCentre = function () {
      path = $location.path().replace(/^\//, '');
      return path.split('/')[0];
    };

    useUrlParams = function () {
      urlParams = angular.extend( $location.search(), { centre : getCentre() } );

      params = ParamCleaner.deserialize( urlParams );

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
      Products.get( $location.path(), angular.extend( Search.params(), { page: 1 } ) );
    };

    updateSearch = function () {
      updateProducts();
      updateFilters();
    };

    // Adds params to search from URL string
    executeInitialSearch = function () {
      useUrlParams();
      updateFilters();
    }(); // Self init

    $scope.filterIsAvailable = function ( filterName ) {
      return Search.availableFilters.indexOf( filterName ) !== -1;
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
      Search.resetParams( { centre: getCentre() } );
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