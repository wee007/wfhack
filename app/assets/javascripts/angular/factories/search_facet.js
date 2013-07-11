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
        values = [];
        angular.forEach( facets, function ( facet ) {
          if ( facet.field === facetName ) {
            // Singular facet details are stored on the object
            values = ( facet.values.length ) ? facet.values : [facet];
          }
        });

        return values;
      }
    };
  });
}( angular.module( 'Westfield' ) ));