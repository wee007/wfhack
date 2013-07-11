( function ( app ) {
  // Search
  // http://product-service.systest.dbg.westfield.com/api/product/latest/products/search.json?centre=bondijunction
  app.service( 'Search', function ( $http, ParamCleaner, SearchFacet ) {
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
    this.params = {};
    angular.extend( this.params, defaultParams );

    this.categories = [];
    this.products = [];
    this.retailers = [];
    this.brands = [];
    this.price = {};

    this.sortOptions = [];
    this.availableFilters = [];
    this.appliedFilters = [];

    this.getSearch = function ( callback ) {
      return $http.get('http://productservice.syt2.dbg.westfield.com/api/product/latest/products/search.json', {
        params: ParamCleaner.build( this.params )
      }).then( function( response ) {
        if ( angular.isFunction( callback ) ) { callback(); }
        self.formatSearchResults( response.data );
      });
    };

    // The current category facet could be 'super_cat', 'category', 'sub_category' or 'type'
    this.getCategoryFacet = function ( facets ) {
      var category = {},
          possibleCategories = ['super_cat', 'category', 'sub_category', 'type'];

      for ( var i = 0; i < possibleCategories.length; i++ ) {
        type = possibleCategories[i];
        category = SearchFacet.retrieve( facets, type );
        if ( category.values ) { break; }
      };

      return category;
    };

    // Return the displayable / human readable
    // filters from the applied_filters.facets object.
    filterBlacklistR = /(centre|on_sale|price)/
    this.formatFilters = function ( filters ) {
      appliedFilters = [];

      // Regular facets
      if ( filters.facets ) {
        for ( var facetName in filters.facets ) {
          if ( facetName.match( filterBlacklistR ) ) { continue; }
          angular.forEach( filters.facets[facetName].selected_values, function ( filter ) {
            appliedFilters.push({
              type: facetName,
              title: filter.title,
              value: filter.value
            });
          });
        }
      };

      // Categories
      if ( filters.categories ) {
        angular.forEach( filters.categories, function ( category ) {
          appliedFilters.push({
            type: category.type,
            title: category.title,
            value: category.value
          });
        });
      }

      return appliedFilters;
    };

    this.formatSearchResults = function ( response ) {
      this.products = response.results;
      this.categories = this.getCategoryFacet( response.facets );

      this.retailers = SearchFacet.retrieve( response.facets, 'retailer' );
      this.brands = SearchFacet.retrieve( response.facets, 'brand' );
      this.price = SearchFacet.retrieve( response.facets, 'price' );

      this.sortOptions = response.display_options.sort_options;
      this.availableFilters = response.available_filters;
      this.appliedFilters = this.formatFilters( response.applied_filters );
    };

    this.setParam = function ( param, value ) {
      // Array params should be added to the 'last'
      // param which will ensure that the full array list
      // is returned for a given facet
      if ( angular.isArray( this.params[param] ) ) {
        this.setParam( 'last', param );
      }

      this.params[param] = value;
    };

    this.removeParam = function ( paramName, value ) {
      param = this.params[paramName];
      if ( angular.isArray( param ) ) {
        index = param.indexOf( value );
        this.params[paramName].splice( index, 1 );
      } else if ( param === value ) {
        delete this.params[paramName];
      }
    };

    this.resetParams = function ( newParams ) {
      this.params = {};
      angular.extend( this.params, defaultParams );
      angular.extend( this.params, newParams );
    };
  });
}( angular.module('Westfield') ));
