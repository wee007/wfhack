( function ( app ) {
  app.controller( 'BrowseController', function ( $scope, CategoryList, Search ) {
    Search.addParam( 'rows', '10' );

    $scope.categories = CategoryList;
    $scope.search = Search;

    // Multi-facet search fields
    $scope.selectedRetailers = [];
    $scope.selectedBrands = [];

    // TODO
    // available_filters
    // super_cat
    // category
    // sub category is multi-value


    // router
    // /bondijunction/products?retailer[]=supre
    // search by multi-centre - centre[]
    // centre[]=all

    // supré vs supre in filtering down results

    // Multi-value facets must be sent back using the original
    // name of the model. eg. selectedBrands should become brands
    // Use this method instead of filterSearch for multi-value fields

    var searchParamMap = {
      'selectedRetailers': 'retailer',
      'selectedBrands': 'brand',
      'price-min': 'price',
      'price-max': 'price'
    };

    $scope.removeSelectedFilter = function ( paramName, paramValue ) {
      Search.removeParam( paramName, paramValue );
      Search.getSearch();
    };

    $scope.multiValueFacetSearch = function ( modelName ) {
      name = searchParamMap[modelName];

      Search.addParam( name, $scope[modelName] );
      Search.getSearch();
    };

    $scope.filterSearch = function ( modelName ) {
      Search.addParam( modelName, $scope[modelName] );
      Search.getSearch();
    };
  });
}( angular.module( 'Westfield' ) ));