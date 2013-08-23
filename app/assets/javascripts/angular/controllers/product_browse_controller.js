( function ( app ) {
  app.controller( 'ProductBrowseController', ['$scope', '$window', '$filter', '$location', '$element', 'ParamCleaner', 'ProductSearch', 'Products', function ( $scope, $window, $filter, $location, $element, ParamCleaner, ProductSearch, Products ) {
    $scope.search = ProductSearch;

    ProductSearch.onChange( function () {
      cleanParams = ParamCleaner.build( ProductSearch.params() );
      $location.search( cleanParams );
      updateProducts();
    });

    // Multi-facet search fields
    $scope.categories = [];
    $scope.retailers = [];
    $scope.brands = [];
    $scope.colours = [];
    $scope.sizes = [];

    // Multi-value facets must be sent back using the original
    // name of the model. eg. 'brands' should become 'brand'
    var searchParamMap = {
      'categories': 'sub_category',
      'retailers': 'retailer',
      'brands': 'brand',
      'colours': 'colour',
      'sizes': 'size'
    };

    getCentre = function () {
      // $location.path() returns the wrong path
      // due to inconsistant issues in the angular router code
      // using document.location because is consistant across browsers
      path = document.location.pathname.replace(/^\//, '');
      return path.split('/')[0];
    };

    useUrlParams = function () {
      var urlParams = $location.search();

      // If there is not centre supplied in the query string,
      // retrieve it from the route
      if ( !urlParams.centre ) { urlParams.centre = getCentre(); }

      params = ParamCleaner.deserialize( urlParams );

      angular.forEach( params, function ( param, key ) {
        // Add params to the controller
        // not all params will be used by the view
        // but we'll map them anyway.
        $scope[key] = param;
        ProductSearch.setParam( key, param );
      });
    };

    updateProducts = function () {
      Products.get( document.location.pathname, angular.extend( ProductSearch.params(), { page: 1 } ) );
    };

    $scope.bootstrap = function () {
      ProductSearch.formatSearchResults( $window.westfield.products );
      useUrlParams();

      if ( !$scope.sort ) $scope.sort = '';
    };

    $scope.updateSearch = function () {
      ProductSearch.getSearch();
      $scope.closeFilters();
    };

    // Filter controls / toggle / open / close
    $scope.activeFilter = '';
    $scope.toggleFilter = function ( filterName ) {
      if ( $scope.activeFilter !== filterName ) {
        $scope.activeFilter = filterName;

        // The button must be hidden on palm breakpoint
        if ( !angular.element('html').hasClass('lap-lrg') ) {
          $scope.hideFilterButtons();
        }
      } else {
        $scope.closeFilters();
      }
    };

    // Filter buttons are hidden on mobile in certain circumstances,
    // this ensures that they're visible when this is clicked (resets the interface)
    $scope.showFilterButtons = function () {
      angular.element('.filters__trigger').show();
    };

    $scope.hideFilterButtons = function () {
      angular.element('.filters__trigger').hide();
    };

    $scope.closeFilters = function () {
      $scope.activeFilter = '';
      $scope.showFilterButtons();
    };

    $scope.hasActiveFilters = function () {
      return !!ProductSearch.appliedFilters.length;
    };

    $scope.filterIsAvailable = function ( filterValues ) {
      return filterValues !== undefined;
    };

    $scope.removeSelectedFilter = function ( paramName, paramValue ) {
      ProductSearch.removeParam( paramName, paramValue );
      $scope.updateSearch();
    };

    $scope.filterSearch = function ( modelName ) {
      ProductSearch.setParam( modelName, $scope[modelName] );
      $scope.updateSearch();
    };

    // multi-facet filter search
    $scope.mvFilterSearch = function ( attributeName ) {
      selectedValues = $filter('filter')($scope.search[attributeName].values, { selected: true });

      values = [];
      angular.forEach( selectedValues, function ( selectedValue ) {
        values.push( selectedValue.code );
      });

      if ( searchParamMap[attributeName] !== undefined ) { attributeName = searchParamMap[attributeName]; }
      ProductSearch.setParam( attributeName, values );
      $scope.updateSearch();

      $scope.closeFilters();
    };

    $scope.clearFilters = function () {
      ProductSearch.resetParams( { centre: getCentre() } );
      $scope.updateSearch();
    };

    $scope.filterCategory = function ( categoryType, categoryCode ) {
      $scope.closeFilters();
      ProductSearch.setParam( categoryType, categoryCode );
      $scope.updateSearch();
    };

    $scope.rangeFilter = function ( paramName ) {
      min = $scope.search[paramName].values.range_start;
      max = $scope.search[paramName].values.range_end;
      paramValue = min + '-' + max;

      ProductSearch.setParam( paramName, paramValue );
    };
  }]);
}( angular.module( 'Westfield' ) ));
