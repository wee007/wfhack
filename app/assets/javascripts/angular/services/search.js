( function ( app ) {
  app.service( 'Search', ['$http', 'ParamCleaner', 'AppliedFilters', 'SearchFacet', function ( $http, ParamCleaner, AppliedFilters, SearchFacet ) {
    var self = this;

    // Params, with types
    // Types are supplied as either defaults
    // or to signify multi-value facets
    defaultParams = {
      type: [],
      brand: [],
      retailer: [],
      colour: [],
      size: [],
      centre: [],
      last: "",
      rows: 15
    };

    // Params can be reset to the defaults, so we'll dupe
    // the object so that it can be modified without polluting the original object
    params = {};
    angular.extend( params, defaultParams );

    this.categories = [];
    this.retailers = [];
    this.brands = [];
    this.colours = [];
    this.sizes = [];
    this.price = {};

    this.sortOptions = [];
    this.availableFilters = [];
    this.appliedFilters = [];

    this.getSearch = function ( callback ) {
      $http.get('/api/product/master/products/search.json', {
        params: ParamCleaner.build( params )
      }).then( function( response ) {
        if ( angular.isFunction( callback ) ) { callback(); }
        self.formatSearchResults( response.data );
      });
    };

    // The current category facet could be 'super_cat', 'category' or 'sub_category'
    this.getCategoryFacet = function ( facets ) {
      var category = {},
          possibleCategories = ['super_cat', 'category', 'sub_category'];

      for ( var i = 0; i < possibleCategories.length; i++ ) {
        type = possibleCategories[i];
        category = SearchFacet.retrieve( facets, type );
        if ( category.values ) { break; }
      };

      return category;
    };

    this.formatSearchResults = function ( response ) {
      this.categories = this.getCategoryFacet( response.facets );

      this.retailers = SearchFacet.retrieve( response.facets, 'retailer' );
      this.brands = SearchFacet.retrieve( response.facets, 'brand' );
      this.price = SearchFacet.retrieve( response.facets, 'price' );
      this.colours = SearchFacet.retrieve( response.facets, 'colour' );
      this.sizes = SearchFacet.retrieve( response.facets, 'size' );

      this.sortOptions = response.display_options.sort_options;
      this.availableFilters = response.available_filters;
      this.appliedFilters = AppliedFilters.format( response.applied_filters );
    };

    this.params = function () {
      return angular.extend( {}, params );
    };

    this.setParam = function ( param, value ) {
      // Array params should be added to the 'last'
      // param which will ensure that the full array list
      // is returned for a given facet
      if ( angular.isArray( params[param] ) ) {
        this.setParam( 'last', param );
      }

      params[param] = value;
    };

    this.removeParam = function ( paramName, value ) {
      param = params[paramName];
      if ( angular.isArray( param ) ) {
        index = param.indexOf( value );
        params[paramName].splice( index, 1 );
      } else if ( param === value ) {
        delete params[paramName];
      }
    };

    this.resetParams = function ( newParams ) {
      params = {};
      angular.extend( params, defaultParams );
      angular.extend( params, newParams );
    };
  }]);
}( angular.module('Westfield') ));
