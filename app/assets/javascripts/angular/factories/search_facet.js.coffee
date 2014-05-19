((app) ->

  #
  #    A utility to collect a given facet by name from Solr
  #
  #    @param facets:
  #    [
  #      {
  #        field: 'price',
  #        min: 0,
  #        max: 10000,
  #        etc, etc
  #      },
  #      {
  #        field: 'brand',
  #        values: [
  #          {
  #            name: 'Nike',
  #            code: 'nike',
  #            count: 125
  #          }
  #        ]
  #      }
  #    ]
  #
  #    @returns: A single facet, an array of values
  #
  app.factory "SearchFacet", ->
    retrieve: (facets, facetName) ->
      facetObject = {}
      angular.forEach facets, (facet) ->
        if facet.field is facetName
          # Singular facet details are stored on the object
          facetObject =
            field: facet.field
            title: facet.title
            values: (if (facet.values and facet.values.length) then facet.values else facet)
            resultsCount: facet.values.length
      facetObject

) angular.module("Westfield")