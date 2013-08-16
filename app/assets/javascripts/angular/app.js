var app = angular.module( 'Westfield', ['ngTouch', 'ngSanitize'] );

app.config(['$httpProvider', '$locationProvider', function ( $httpProvider, $locationProvider ) {
  // Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

  $locationProvider.html5Mode(true).hashPrefix( '!' );
}]);
