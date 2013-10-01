app = angular.module("Westfield", ["ngMobile", "ngSanitize"])
app.config ["$httpProvider", "$locationProvider", ($httpProvider, $locationProvider) ->

  # Tell rails that we're using XMLHttpRequests
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest"
  $locationProvider.html5Mode(true).hashPrefix "!"
]