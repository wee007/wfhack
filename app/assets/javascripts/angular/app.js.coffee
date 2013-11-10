app = angular.module("Westfield", ["ngTouch", "ngSanitize", "ngAnimate", "ngRoute"])
app.config ["$httpProvider", "$locationProvider", "$routeProvider", ($httpProvider, $locationProvider, $routeProvider) ->

  # Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest"

  $locationProvider.html5Mode(true).hashPrefix('!')

  $routeProvider.when('/:centre?/browse/:super_cat?/:category?',
    templateUrl: 'ProductBrowseView',
    controller: 'ProductBrowseController'
  )
]