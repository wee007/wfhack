( function ( app ) {
  app.service( 'Products', function( $http, ParamCleaner ) {
    this.list = '';
    this.loaded = true;

    this.get = function ( url, params, callback ) {
      this.loaded = false;

      angular.extend( params, {
        url: url,
        method: 'GET',
        params: ParamCleaner.build( params )
      });

      var self = this;
      $http( params ).success( function ( response ) {
        self.loaded = true;
        self.list = response;
        if ( angular.isFunction( callback ) ) { callback(); }
      });
    }
  });
}( angular.module( 'Westfield' ) ));