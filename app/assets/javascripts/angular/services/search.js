( function ( app ) {
  // Search
  // http://product-service.systest.dbg.westfield.com/api/product/latest/products/search.json?centre=bondijunction
  app.service( 'Search', function ( $http ) {
    var self = this;

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
      var params = this.params;

      for ( var param in params ) {
        if ( angular.isArray( this.params[param] ) && !this.params[param].length ) {
          delete params[param];
        }

        // Fixing angular bug https://github.com/angular/angular.js/issues/3121
        if ( angular.isArray( this.params[param] ) ) {
          paramName = param + '[]';
          params[paramName] = params[param];
          delete params[param];
        }
      };

      return params;
    };

    this.formatSearchResults = function ( response ) {
      this.products = response.results;
      this.retailers = this.getFacet( response.facets, 'retailer' );
      this.brands = this.getFacet( response.facets, 'brand' );
      this.sortOptions = response.display_options.sort_options;
    };

    this.getFacet = function ( facets, facetName ) {
      var values = [];
      angular.forEach( facets, function ( facet ) {
        if ( facet.field === facetName ) {
          values = facet.values;
        }
      });

      return values;
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

    this.removeParam = function ( param, value ) {
      var index;
      if ( angular.isArray( this.params[param] ) ) {
        index = this.params[param].indexOf( value );
        this.params[param].splice( index, 1 );
      } else {
        delete this.params[param];
      }
    };

    this.getSearch();
  });
}( angular.module('Westfield') ));
