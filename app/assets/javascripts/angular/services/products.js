( function ( app ) {
  app.service( 'Products', function( $http, $sce, ParamCleaner ) {
    var callbacks = [];
    this.list = '';
    this.loaded = true;

    this.onChange = function ( callback ) {
      if ( angular.isFunction( callback ) ) {
        callbacks.push( callback );
      }
    };

    this.get = function ( url, params ) {
      this.loaded = false;

      angular.extend( params, {
        url: url,
        method: 'GET',
        params: ParamCleaner.build( params )
      });

      var self = this;
      $http( params ).success( function ( response ) {
        self.loaded = true;
        self.list = $sce.trustAsHtml(response);
        angular.forEach( callbacks, function ( callback ) { callback( self.list ); } );
      });
    }
  });
}( angular.module( 'Westfield' ) ));