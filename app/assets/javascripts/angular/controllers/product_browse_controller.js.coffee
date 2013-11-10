((app) ->
  app.controller "ProductBrowseController", ["$scope", "$window", "$filter", "$location", "$route", "$routeParams", "ParamCleaner", "ProductSearch", "Products", ($scope, $window, $filter, $location, $route, $routeParams, ParamCleaner, ProductSearch, Products) ->
    $scope.search = ProductSearch

    # Route changes
    $scope.$on '$routeChangeStart', (event, to, from) -> useUrlParams( to.params )
    $scope.$on '$routeChangeSuccess', (event, to, from) -> $scope.updateSearch() unless from == undefined or from == to

    ProductSearch.onChange -> updateProducts()

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

    useUrlParams = ( urlParams = {} ) ->
      # Add querystrings like last=, rows= & page=, as well
      # as overwriting the centre (for use when multiple centres are selected)
      params = angular.extend( urlParams, $location.search() )

      # Remove any square bracket key[]= notation
      params = ParamCleaner.deserialize( params )

      # Hack for IE :-(
      if !params.centre
        routeChunks = document.location.pathname.replace(/^\//, "").split("/")
        centre = routeChunks[0]
        # If its 'browse', or whatever the route becomes
        params.centre = centre unless routeChunks.length == 1

      # Remove any params that won't be overwritten by the new params
      ProductSearch.resetParams( params )

      # Add params to the controller not all params will be
      # used by the view but we'll map them anyway.
      angular.forEach params, (param, key) -> $scope[key] = param

    setParams = ->
      rParams = routeParams()
      qsParams = queryStringParams()

      # Collect routeable params remove undefined
      rParams = [rParams.centre, 'browse', rParams.super_cat, rParams.category].filter (o) -> o

      $location.path(rParams.join('/')).search(ParamCleaner.build(qsParams))

    routeParams = ->
      params = ProductSearch.params()

      (
        centre: params.centre
        super_cat: params.super_cat
        category: params.category
      )

    queryStringParams = ->
      newParams = ProductSearch.params()

      # Never place these params into querystrings
      delete newParams.super_cat
      delete newParams.category

      newParams

    # Update products using the same url that we're currently using
    # document.location.pathname == /browse
    # document.location.pathname == /bondijunction/browse
    # document.location.pathname == /bondijunction/browse/womens
    # document.location.pathname == /bondijunction/browse/womens-fashion-accessories
    updateProducts = ->
      Products.get document.location.pathname, ProductSearch.params()

    bootstrap = (->
      ProductSearch.formatSearchResults $window.westfield.products
      useUrlParams($routeParams)
      $scope.sort = "" unless $scope.sort
    )()

    $scope.go = (event, path) ->
      $location.path(path)
      event.preventDefault()

    $scope.updateSearch = ->
      Products.loading = true
      ProductSearch.getSearch()
      $scope.closeFilters()

    # Filter controls / toggle / open / close
    $scope.activeFilter = ""
    $scope.toggleFilter = (filterName) ->
      if $scope.activeFilter isnt filterName
        $scope.activeFilter = filterName

        # The button must be hidden on Lap large breakpoint
        $scope.hideFilterButtons() unless angular.element("html").hasClass("lap-lrg")
      else
        $scope.closeFilters()


    # Filter buttons are hidden on mobile in certain circumstances,
    # this ensures that they're visible when this is clicked (resets the interface)
    $scope.triggersVisible = false
    $scope.showFilterButtons = -> $scope.triggersVisible = true
    $scope.hideFilterButtons = -> $scope.triggersVisible = false

    $scope.closeFilters = ->
      $scope.activeFilter = ""
      $scope.showFilterButtons()

    $scope.hasActiveFilters = ->
      !!ProductSearch.appliedFilters.length

    $scope.filterIsAvailable = (filterValues) ->
      filterValues isnt `undefined`

    # For querystring params
    $scope.removeSelectedFilter = (filter) ->
      ProductSearch.removeParam filter.type, filter.value
      setParams()

    $scope.removeAllFilters = -> $scope.search.appliedFilters = []

    $scope.filterSearch = (modelName) ->
      ProductSearch.setParam modelName, $scope[modelName]
      setParams()

    # multi-facet filter search
    $scope.mvFilterSearch = (attributeName) ->
      selectedValues = $filter("filter")($scope.search[attributeName].values,
        selected: true
      )
      values = []
      angular.forEach selectedValues, (selectedValue) ->
        values.push selectedValue.code

      attributeName = searchParamMap[attributeName]  if searchParamMap[attributeName] isnt `undefined`
      ProductSearch.setParam attributeName, values
      setParams()
      $scope.closeFilters()

    $scope.filterCategory = (categoryType, categoryCode) ->
      $scope.closeFilters()
      ProductSearch.setParam categoryType, categoryCode
      setParams()

    $scope.rangeFilter = (paramName) ->
      min = $scope.search[paramName].values.range_start
      max = $scope.search[paramName].values.range_end
      paramValue = min + "-" + max
      ProductSearch.setParam paramName, paramValue

  ]
) angular.module("Westfield")