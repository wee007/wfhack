((app) ->
  app.service "GlobalSearch", ['$http', ($http) ->
    callbacks = []
    @results = []
    @loaded = true
    @onChange = (callback) ->
      callbacks.push callback if angular.isFunction(callback)

    @get = (params) ->
      @loaded = false
      params =
        url: "/api/search/master/search.json"
        method: "GET"
        params: params

      self = this

      $http(params).success (response) ->
        self.loaded = true
        self.results = response.results
        angular.forEach callbacks, (callback) -> callback()
  ]
) angular.module("Westfield")
