( function ( app ) {
  // Category list
  // http://product-service.systest.dbg.westfield.com/api/product/latest/categories.json?hierarchy_level=3
  app.service( 'CategoryList', function ( $http ) {
    var self = this;
    this.all = [];

    this.getCategories = function () {
      return $http.get( '/data/categories.json' ).success( function ( response ) {
        self.all = response;
      });
    };

    this.getCategories();
  });
}( angular.module( 'Westfield' ) ));