( function ( app ) {
  // Search
  // http://product-service.systest.dbg.westfield.com/api/product/latest/products/search.json?centre=bondijunction
  app.service( 'Search', function ( $http, ParamCleaner ) {
    var self = this;

    // Params, with types
    // Types are supplied as either defaults
    // or to signify multi-value facets
    this.params = {
      brand: [],
      retailer: [],
      colour: [],
      size: [],
      centre: [],
      rows: 15
    };

    this.super_cats = [];
    this.products = [];
    this.retailers = [];
    this.brands = [];

    this.sortOptions = [];
    this.availableFilters = [];
    this.appliedFilters = [];

    this.getSearch = function ( callback ) {
      return $http.get('http://productservice.syt2.dbg.westfield.com/api/product/latest/products/search.json', {
        params: ParamCleaner.build( this.params ),
        cache: true
      }).then( function( response ) {
        if ( angular.isFunction( callback ) ) { callback(); }
        self.formatSearchResults( response.data );
      });
    };

    this.getFacet = function ( facets, facetName ) {
      values = [];
      angular.forEach( facets, function ( facet ) {
        if ( facet.field === facetName ) {
          values = facet.values;
        }
      });

      return values;
    };

    // Return the displayable / human readable
    // filters from the applied_filters.facets object.
    filterBlacklistR = /(centre|on_sale)/
    this.formatFilters = function ( filters ) {
      appliedFilters = [];
      if ( filters.facets ) {
        for ( var facetName in filters.facets ) {
          if ( facetName.match( filterBlacklistR ) ) { continue; }

          if ( angular.isArray( filters.facets[facetName].selected_values ) ) {
            angular.forEach( filters.facets[facetName].selected_values, function ( filter ) {
              appliedFilters.push({
                type: facetName,
                title: filter.title,
                value: filter.value
              });
            });
          } else {
            value = filters.facets[facetName].selected_values.value;
            appliedFilters.push({
              type: filters.facets[facetName].type,
              title: value,
              value: value
            });
          }
        }
      }

      return appliedFilters;
    };

    this.formatSearchResults = function ( response ) {
      this.products = response.results;
      this.super_cats = this.getFacet( response.facets, 'super_cat' );
      this.retailers = this.getFacet( response.facets, 'retailer' );
      this.brands = this.getFacet( response.facets, 'brand' );
      this.sortOptions = response.display_options.sort_options;
      this.availableFilters = response.available_filters;
      this.appliedFilters = this.formatFilters( response.applied_filters );
    };

    this.addParam = function ( param, value ) {
      // Array params should be added to the 'last'
      // param which will ensure that the full array list
      // is returned for a given facet
      if ( angular.isArray( this.params[param] ) ) {
        this.addParam( 'last', param );
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
  });
}( angular.module('Westfield') ));
