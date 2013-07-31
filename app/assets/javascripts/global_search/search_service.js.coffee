((app) ->
  app.service "GlobalSearch", ['$http', ($http) ->
    callbacks = []
    @list = ""
    @loaded = true
    @onChange = (callback) ->
      callbacks.push callback  if angular.isFunction(callback)

    @get = (url, params) ->
      @loaded = false
      params =
        url: url,
        method: "GET",
        params: params

      self = this
      $http(params).success (response) ->
        self.loaded = true
        self.list = response
        angular.forEach callbacks, (callback) ->
          callback self.list
  ]
) angular.module("Westfield")
