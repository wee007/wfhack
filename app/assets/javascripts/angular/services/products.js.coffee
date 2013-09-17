((app) ->
  app.service "Products", ["$http", "$sce", "ParamCleaner", ($http, $sce, ParamCleaner) ->
    callbacks = []
    @list = ""
    @loaded = false
    @loading = false
    @onChange = (callback) ->
      callbacks.push callback  if angular.isFunction(callback)

    @get = (url, params) ->
      @loaded = false
      @loading = true
      angular.extend params,
        url: url
        method: "GET"
        params: ParamCleaner.build(params)
        cache: true

      self = this
      $http(params).success (response) ->
        self.loaded = true
        self.loading = false
        self.list = $sce.trustAsHtml(response)
        angular.forEach callbacks, (callback) ->
          callback self.list


  ]
) angular.module("Westfield")