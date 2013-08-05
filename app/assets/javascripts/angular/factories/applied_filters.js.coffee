# Return the displayable / human readable
# filters from the applied_filters.facets object.

((app) ->
  app.factory 'AppliedFilters', ->
    # Centres, 'on sale' and price filters should not be shown
    # in active filter / tag list
    filterBlacklistR = /(centre|on_sale|price)/

    collectValues = ( values, type ) ->
      collectedValues = []

      pushValue = (obj) ->
        collectedValues.push({
          value: obj.value
          title: (obj.title or obj.value)
          type: (type or obj.type)
        })

      if angular.isArray values
        angular.forEach values, (value) ->
          pushValue(value)
      else
        pushValue(values)

      collectedValues

    format: (filters) ->
      appliedFilters = []

      # Regular facets
      for name, facet of filters.facets
        continue if name.match(filterBlacklistR)

        facetValues = collectValues facet.selected_values, name
        appliedFilters = appliedFilters.concat facetValues

      # Categories
      categoryValues = collectValues filters.categories
      appliedFilters = appliedFilters.concat categoryValues

      appliedFilters

) angular.module("Westfield")