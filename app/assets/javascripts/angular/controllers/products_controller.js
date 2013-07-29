( function ( app ) {
  app.controller( 'ProductsController', function ( $scope, $window, Products ) {
    $scope.products = Products;

    Products.onChange( function () {
      setTimeout(function () {
        $window.initPlugin.isotope();
      }, 500);
    });

    $scope.nextPage = function () {
      // If we're not already in the process of loading
      if ( Products.isLoading === false ) {
        Products.appendNextPage();
      }
    };
  });
}( angular.module( 'Westfield' ) ) );