((app) ->
  app.controller "ProductBrowseController", ["$rootScope", "$scope", "$window", "$timeout", "$filter", "$location", "$route", "$routeParams", "ParamCleaner", "ProductSearch", "Products", ($rootScope, $scope, $window, $timeout, $filter, $location, $route, $routeParams, ParamCleaner, ProductSearch, Products) ->
    $scope.search = ProductSearch

    # Route changes
    $scope.$on '$routeChangeStart', (event, to, from) -> useUrlParams( to.params )
    $scope.$on '$routeChangeSuccess', (event, to, from) ->
      $scope.updateSearch() unless from == undefined or from == to

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

    # On page load, if there are no products
    # Remove bad params and do a search with no params to get all available params for this centre
    if westfield.products.count == 0
      ProductSearch.resetParams()
      ProductSearch.getAvailableFilters $rootScope.centre_id

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

        # If its 'products', or whatever the route becomes
        params.centre = centre unless routeChunks.length == 1 or centre == 'products'

      # Remove any params that won't be overwritten by the new params
      ProductSearch.resetParams( params )

      # Add params to the controller not all params will be
      # used by the view but we'll map them anyway.
      angular.forEach params, (param, key) -> $scope[key] = param

      # Need to trigger an event here so the placeholder polyfill can be reapplied to the page
      # Has to be in a timeout to wait for the page to render
      $timeout ->
        $(document).trigger("products.change")

    setParams = (newAttribute, newValues) ->
      rParams = routeParams()
      qsParams = queryStringParams()

      # New params mean that we need to reset the page QS
      delete qsParams.page

      # When doing a search after a "no products" result
      # Make sure bad params are removed from URL, with only the new param being added
      if westfield.products.count == 0
        qsParams = {}
        qsParams[newAttribute] = newValues

      # Collect routable params, removing undefined
      route = ['products', rParams.super_cat, rParams.category]
      undefinedIndex = route.indexOf(undefined)
      route = route.splice(0, undefinedIndex) if undefinedIndex >= 0

      # Prefix with centre if exists
      route = [rParams.centre].concat route if rParams.centre
      $location.path(route.join('/')).search(ParamCleaner.build(qsParams))

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
      delete newParams.centre
      delete newParams.super_cat
      delete newParams.category

      newParams

    bootstrap = (->
      ProductSearch.formatSearchResults $window.westfield.products
      useUrlParams($routeParams)
      $scope.sort = "" unless $scope.sort
    )()

    $scope.go = (event, path) ->
      # Angular's $location.path wasnt replacing the full URL when there were no products,
      # So use to lower level value to change URL
      if westfield.products.count == 0
        $window.location.href = path
      else
        $location.path(path)
      event.preventDefault()

    $scope.updateSearch = ->
      Products.loading = true
      ProductSearch.getSearch()
      $scope.closeFilters()

      # Need to trigger an event here so the placeholder polyfill can be reapplied to the page
      # Has to be in a timeout to wait for the page to render
      $timeout ->
        $(document).trigger("products.change")


    # Filter controls / toggle / open / close
    $scope.activeFilter = ""
    $scope.toggleFilter = ($event, filterName) ->
      if $scope.activeFilter isnt filterName
        $scope.activeFilter = filterName

        #let other dropdowns know that they should close themselves
        $rootScope.$broadcast "product-filter-dropdown-open"
        SocialShare.closeAll()

        # Stop event from getting to toggle visibility instance for "Filters" mobile button
        # It doesnt need to know as it's not being used at this breakpoint
        if angular.element("html").hasClass("lap-lrg")
          $event.stopPropagation()
        else
          $scope.triggersVisible = false;
      else
        $scope.closeFilters()

      return

    # When a toggle visbility directive is opened close product filter drop downs
    $rootScope.$on "toggle-visibility-dropdowns", ->
      $timeout($scope.closeFilters, 0);

    if angular.element("html").hasClass("lap-lrg")
      $(document).click (event) ->
        # Dont close a filter dropdown if the click came from inside a filter dropdown
        if $(event.target).parents('.js-products-filter-dropdown').length == 0
          $scope.closeFilters()
          $scope.$apply()

      # Escape key will close all filter dropdowns
      $(document).bind "keydown", (event) ->
        $scope.closeFilters() if event.keyCode is 27
        $scope.$apply()

    # Filter buttons are hidden on mobile in certain circumstances,
    # this ensures that they're visible when this is clicked (resets the interface)
    $scope.triggersVisible = true
    $scope.showFilterButtons = -> $scope.triggersVisible = true
    $scope.hideFilterButtons = -> $scope.triggersVisible = false

    $scope.closeFilters = ->
      $scope.activeFilter = ""
      $scope.showFilterButtons()

    window.closeFilters = ->
      $scope.closeFilters()
      $scope.$apply()

    $scope.hasActiveFilters = ->
      !!ProductSearch.appliedFilters.length

    $scope.filterIsAvailable = (filterValues) ->
      filterValues isnt `undefined`

    # For querystring params
    $scope.removeSelectedFilter = (filter) ->
      ProductSearch.removeParam filter.type, filter.value
      setParams()

    $scope.removeAllFilters = ->
      $scope.search.appliedFilters = []

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
      setParams(attributeName, values)
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

    $scope.submitPriceFilter = ->
      $scope.updateSearch()
      setParams()

  ]
) angular.module("Westfield")