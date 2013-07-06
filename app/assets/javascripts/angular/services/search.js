( function ( app ) {
  // Search
  // http://product-service.systest.dbg.westfield.com/api/product/latest/products/search.json?centre=bondijunction
  app.service( 'Search', function ( $http ) {
    // Params, with types
    this.params = {
      brand: [],
      retailer: [],
      colour: [],
      size: [],
      rows: 10
    };

    this.products = [];
    this.retailers = [];
    this.brands = [];
    this.sortOptions = [];
    this.availableFilters = [];
    this.appliedFilters = [];

    var self = this;
    this.getSearch = function () {
      return $http.get('http://productservice.syt2.dbg.westfield.com/api/product/latest/products/search.json', {
        params: this.buildRequestParams(),
        cache: true
      }).then( function( response ) {
        self.formatSearchResults( response.data );
      });
    };

    // Params will be modified prior to being sent to the server.
    // This ensures that array based params will not be sent as empty arrays.
    this.buildRequestParams = function () {
      params = {};
      angular.extend( params, this.params );

      for ( var param in params ) {
        // No need to transmit empty values
        if ( typeof params[param] === 'string' || angular.isArray( params[param] ) ) {
          if ( !params[param].length ) delete params[param];
        }

        // False booleans can be omitted
        if ( params[param] === false ) {
          delete params[param];
        }

        // Solr expects arrays to be passed as key[]=value
        if ( angular.isArray( params[param] ) ) {
          paramName = param + '[]';
          params[paramName] = params[param];
          delete params[param];
        }
      };

      return params;
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
    this.formatFilters = function ( filters ) {
      appliedFilters = [];
      if ( filters.facets ) {
        for ( var facetName in filters.facets ) {
          angular.forEach( filters.facets[facetName].selected_values, function ( filter ) {
            if ( filter.title ) {
              appliedFilters.push({
                type: facetName,
                title: filter.title,
                value: filter.value
              });
            }
          });
        }
      }

      return appliedFilters;
    };

    this.formatSearchResults = function ( response ) {
      this.products = response.results;
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
        param.splice( index, 1 );
      } else if ( param === value ) {
        delete param;
      }
    };

    this.getSearch();
  });
}( angular.module('Westfield') ));
