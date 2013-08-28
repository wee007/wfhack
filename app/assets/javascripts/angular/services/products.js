( function ( app ) {
  app.service( 'Products', ['$http', '$sce', 'ParamCleaner', function( $http, $sce, ParamCleaner ) {
    var callbacks = [];
    this.list = '';
    this.loaded = false;
    this.loading = false;

    this.onChange = function ( callback ) {
      if ( angular.isFunction( callback ) ) {
        callbacks.push( callback );
      }
    };

    this.get = function ( url, params ) {
      this.loaded = false;
      this.loading = true;

      angular.extend( params, {
        url: url,
        method: 'GET',
        params: ParamCleaner.build( params )
      });

      var self = this;
      $http( params ).success( function ( response ) {
        self.loaded = true;
        self.loading = false;
        self.list = $sce.trustAsHtml(response);
        angular.forEach( callbacks, function ( callback ) { callback( self.list ); } );
      });
    }
  }]);
}( angular.module( 'Westfield' ) ));
