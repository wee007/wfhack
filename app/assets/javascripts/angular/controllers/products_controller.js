( function ( app ) {
  app.controller( 'ProductsController', ['$scope', '$window', 'Products', function ( $scope, $window, Products ) {
    $scope.products = Products;
  }]);
}( angular.module( 'Westfield' ) ) );
