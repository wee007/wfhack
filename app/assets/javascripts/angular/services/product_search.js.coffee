((app) ->
  app.service "ProductSearch", ["$http", "ParamCleaner", "AppliedFilters", "SearchFacet", "SortOptions", ($http, ParamCleaner, AppliedFilters, SearchFacet, SortOptions) ->
    self = this
    defaultParams =

      # Params, with types
      # Types are supplied as either defaults
      # or to signify multi-value facets
      type: []
      brand: []
      retailer: []
      colour: []
      size: []
      centre: []
      last: ""
      rows: 15
      page: 1

    callbacks = []

    # Params can be reset to the defaults, so we'll dupe
    # the object so that it can be modified without polluting the original object
    params = {}
    angular.extend params, defaultParams
    @categories = []
    @retailers = []
    @brands = []
    @colours = []
    @sizes = []
    @price = {}
    @sortOptions = []
    @appliedFilters = []
    @onChange = (callback) ->
      if angular.isFunction(callback)
        callbacks.push callback

    @getSearch = (callback) ->

      angular.forEach callbacks, (callback) -> callback()

      $http.get("/api/product/master/products/search.json",
        params: ParamCleaner.build(params)
        cache: true
      ).then (response) ->
        self.formatSearchResults response.data


    # The current category facet could be 'super_cat', 'category' or 'sub_category'
    @getCategoryFacet = (facets) ->
      category = {}
      possibleCategories = ["super_cat", "category", "sub_category"]
      i = 0

      while i < possibleCategories.length
        type = possibleCategories[i]
        category = SearchFacet.retrieve(facets, type)
        break  if category.values
        i++
      category

    @formatSearchResults = (response) ->
      @count = response.count
      @categories = @getCategoryFacet(response.facets)
      @retailers = SearchFacet.retrieve(response.facets, "retailer")
      @brands = SearchFacet.retrieve(response.facets, "brand")
      @price = SearchFacet.retrieve(response.facets, "price")
      @colours = SearchFacet.retrieve(response.facets, "colour")
      @sizes = SearchFacet.retrieve(response.facets, "size")
      @sortOptions = SortOptions.format(response.display_options.sort_options)
      @appliedFilters = AppliedFilters.format(response.applied_filters)

    @params = ->
      angular.extend {}, params

    @setParam = (param, value) ->

      # Array params should be added to the 'last'
      # param which will ensure that the full array list
      # is returned for a given facet
      @setParam "last", param  if angular.isArray(params[param])
      params[param] = value

    @removeParam = (paramName, value) ->
      param = params[paramName]
      if angular.isArray(param)
        index = param.indexOf(value)
        params[paramName].splice index, 1
      else delete params[paramName]  if param is value

    @resetParams = (newParams) ->
      params = {}
      angular.extend params, defaultParams
      angular.extend params, newParams
  ]
) angular.module("Westfield")