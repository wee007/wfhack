var app = angular.module( 'Westfield', ['ngRoute', 'ngMobile'] );

app.config(function ( $httpProvider, $routeProvider, $locationProvider ) {
  // Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

  // Routes
  $routeProvider.when( '/:centre/products', {
    controller: 'BrowseController',
    templateUrl: 'productBrowseTemplate'
  });

  // Use pushState, and hashbang (for google)
  $locationProvider.hashPrefix( '!' );
  $locationProvider.html5Mode( true );
});