((app) ->
  app.service "GlobalSearch", ['$http', '$q', ($http, $q) ->
    callbacks = []
    @results = []
    @loaded = true
    @canceler = false
    @onChange = (callback) ->
      callbacks.push callback if angular.isFunction(callback)

    @get = (params) ->
      @loaded = false
      if @canceler
        @canceler.resolve()
      @canceler = $q.defer()
      params =
        url: "/api/search/master/search.json"
        method: "GET"
        params: params
        timeout: @canceler.promise

      self = this
      $http(params).success (response) ->
        self.loaded = true
        self.results = response.results
        angular.forEach callbacks, (callback) -> callback()
  ]
) angular.module("Westfield")
