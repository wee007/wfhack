var app = angular.module( 'Westfield', ['ngMobile'] );

app.config(function ( $httpProvider, $locationProvider ) {
  // Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

  $locationProvider.html5Mode(true);
});