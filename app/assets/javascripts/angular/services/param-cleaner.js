( function ( app ) {
  app.service( 'ParamCleaner', function () {
    this.arrayParamR = /\[\]$/

    // This ensures that params are packaged up in the format that
    // solr/the search api expects
    this.build = function ( params ) {
      cleanedParams = {};
      angular.extend( cleanedParams, params );

      for ( var param in cleanedParams ) {
        // No need to transmit empty values
        if ( angular.isString( cleanedParams[param] ) || angular.isArray( cleanedParams[param] ) ) {
          if ( !cleanedParams[param].length ) delete cleanedParams[param];
        }

        // False booleans can be omitted
        if ( cleanedParams[param] === false ) {
          delete cleanedParams[param];
        }

        // Solr expects arrays to be passed as key[]=value
        if ( angular.isArray( cleanedParams[param] ) && !param.match( this.arrayParamR ) ) {
          paramName = param + '[]';
          cleanedParams[paramName] = cleanedParams[param];
          delete cleanedParams[param];
        }
      };
      return cleanedParams;
    };

    this.deserialize = function ( params ) {
      for ( var key in params ) {
        if ( key.match( this.arrayParamR ) ) {
          cleanKey = key.replace( this.arrayParamR, '' );
          params[cleanKey] = params[key];
          delete params[key];
        }
      }
      return params;
    }
  });
}( angular.module( 'Westfield' ) ));