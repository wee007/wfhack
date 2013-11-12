app = angular.module("Westfield", ["ngTouch", "ngSanitize", "ngRoute"])
app.config ["$httpProvider", "$locationProvider", "$routeProvider", ($httpProvider, $locationProvider, $routeProvider) ->

  # Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest"
  $httpProvider.defaults.headers.common["Vary"] = "X-Requested-With"

  $locationProvider.html5Mode(true).hashPrefix('!')

  $routeProvider.when('/:centre?/products/:super_cat?/:category?',
    templateUrl: 'ProductBrowseView',
    controller: 'ProductBrowseController'
  )
]