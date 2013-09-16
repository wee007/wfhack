((app) ->
  app.controller "ProductBrowseController", ["$scope", "$window", "$filter", "$location", "$element", "ParamCleaner", "ProductSearch", "Products", ($scope, $window, $filter, $location, $element, ParamCleaner, ProductSearch, Products) ->
    $scope.search = ProductSearch
    ProductSearch.onChange ->
      cleanParams = ParamCleaner.build(ProductSearch.params())
      $location.search cleanParams
      updateProducts()


    # Multi-facet search fields
    $scope.categories = []
    $scope.retailers = []
    $scope.brands = []
    $scope.colours = []
    $scope.sizes = []

    # Multi-value facets must be sent back using the original
    # name of the model. eg. 'brands' should become 'brand'
    searchParamMap =
      categories: "sub_category"
      retailers: "retailer"
      brands: "brand"
      colours: "colour"
      sizes: "size"

    getCentre = ->

      # $location.path() returns the wrong path
      # due to inconsistant issues in the angular router code
      # using document.location because is consistant across browsers
      path = document.location.pathname.replace(/^\//, "")
      path.split("/")[0]

    useUrlParams = ->
      urlParams = $location.search()

      # If there is not centre supplied in the query string,
      # retrieve it from the route
      urlParams.centre = getCentre()  unless urlParams.centre
      params = ParamCleaner.deserialize(urlParams)
      angular.forEach params, (param, key) ->

        # Add params to the controller
        # not all params will be used by the view
        # but we'll map them anyway.
        $scope[key] = param
        ProductSearch.setParam key, param


    updateProducts = ->
      Products.get document.location.pathname, angular.extend(ProductSearch.params(),
        page: 1
      )

    $scope.bootstrap = ->
      ProductSearch.formatSearchResults $window.westfield.products
      useUrlParams()
      $scope.sort = ""  unless $scope.sort

    $scope.updateSearch = ->
      ProductSearch.getSearch()
      $scope.closeFilters()


    # Filter controls / toggle / open / close
    $scope.activeFilter = ""
    $scope.toggleFilter = (filterName) ->
      if $scope.activeFilter isnt filterName
        $scope.activeFilter = filterName

        # The button must be hidden on palm breakpoint
        $scope.hideFilterButtons()  unless angular.element("html").hasClass("lap-lrg")
      else
        $scope.closeFilters()


    # Filter buttons are hidden on mobile in certain circumstances,
    # this ensures that they're visible when this is clicked (resets the interface)
    $scope.showFilterButtons = ->
      angular.element(".filters__trigger").show()

    $scope.hideFilterButtons = ->
      angular.element(".filters__trigger").hide()

    $scope.closeFilters = ->
      $scope.activeFilter = ""
      $scope.showFilterButtons()

    $scope.hasActiveFilters = ->
      !!ProductSearch.appliedFilters.length

    $scope.filterIsAvailable = (filterValues) ->
      filterValues isnt `undefined` and filterValues.length > 0

    $scope.removeSelectedFilter = (paramName, paramValue) ->
      Products.loading = true
      ProductSearch.removeParam paramName, paramValue
      $scope.updateSearch()

    $scope.filterSearch = (modelName) ->
      Products.loading = true
      ProductSearch.setParam modelName, $scope[modelName]
      $scope.updateSearch()


    # multi-facet filter search
    $scope.mvFilterSearch = (attributeName) ->
      Products.loading = true
      selectedValues = $filter("filter")($scope.search[attributeName].values,
        selected: true
      )
      values = []
      angular.forEach selectedValues, (selectedValue) ->
        values.push selectedValue.code

      attributeName = searchParamMap[attributeName]  if searchParamMap[attributeName] isnt `undefined`
      ProductSearch.setParam attributeName, values
      $scope.updateSearch()
      $scope.closeFilters()

    $scope.clearFilters = ->
      Products.loading = true
      ProductSearch.resetParams centre: getCentre()
      $scope.updateSearch()

    $scope.filterCategory = (categoryType, categoryCode) ->
      Products.loading = true
      $scope.closeFilters()
      ProductSearch.setParam categoryType, categoryCode
      $scope.updateSearch()

    $scope.rangeFilter = (paramName) ->
      min = $scope.search[paramName].values.range_start
      max = $scope.search[paramName].values.range_end
      paramValue = min + "-" + max
      ProductSearch.setParam paramName, paramValue
  ]
) angular.module("Westfield")