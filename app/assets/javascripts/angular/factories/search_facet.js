(function ( app ) {
  /*
    A utility to collect a given facet by name from Solr

    @param facets:
    [
      {
        field: 'price',
        min: 0,
        max: 10000,
        etc, etc
      },
      {
        field: 'brand',
        values: [
          {
            name: 'Nike',
            code: 'nike',
            count: 125
          }
        ]
      }
    ]

    @returns: A single facet, an array of values
  */
  app.factory( 'SearchFacet', function (  ) {
    return {
      retrieve: function ( facets, facetName ) {
        facetObject = {};
        angular.forEach( facets, function ( facet ) {
          if ( facet.field === facetName ) {
            // Singular facet details are stored on the object
            facetObject = {
              field: facet.field,
              values: ( facet.values.length ) ? facet.values : [facet]
            }
          }
        });

        return facetObject;
      }
    };
  });
}( angular.module( 'Westfield' ) ));