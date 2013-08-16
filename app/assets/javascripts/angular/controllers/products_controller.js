( function ( app ) {
  app.controller( 'ProductsController', ['$scope', '$window', 'Products', function ( $scope, $window, Products ) {
    $scope.products = Products;

    Products.onChange( function () {
      setTimeout(function () {
        $window.initPlugin.isotope();
      }, 500);
    });
  }]);
}( angular.module( 'Westfield' ) ) );
