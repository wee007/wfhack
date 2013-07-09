var app = angular.module( 'Westfield', ['ngRoute'] );

app.config(function ( $httpProvider, $routeProvider, $locationProvider ) {
  // Allow CORS
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

  // Routes
  $routeProvider.when( '/:centre/products', {
    controller: 'BrowseController',
    templateUrl: 'productBrowseTemplate'
  });

  // Use pushState
  $locationProvider.hashPrefix( '!' );
  $locationProvider.html5Mode( true );
});