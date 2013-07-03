( function ( app ) {
  app.controller( 'BrowseController', function ( $scope, $filter, CategoryList, Search ) {
    Search.addParam( 'rows', '10' );

    $scope.categories = CategoryList;
    $scope.search = Search;
    $scope.selectedCategories = [];

    // Multi-facet search fields
    $scope.selectedRetailers = [];
    $scope.selectedBrands = [];

    // Multi-value facets must be sent back using the original
    // name of the model. eg. selectedBrands should become brands
    // Use this method instead of filterSearch for multi-value fields

    var multiValueFacetMap = {
      'selectedRetailers': 'retailer',
      'selectedBrands': 'brand'
    };

    $scope.multiValueFacet = function ( modelName ) {
      name = multiValueFacetMap[modelName];

      Search.addParam( name, $scope[modelName] );
      Search.getSearch();
    }

    $scope.filterSearch = function ( modelName ) {
      Search.addParam( modelName, $scope[modelName] );
      Search.getSearch();
    };

    $scope.categories = [{
      name: 'Brand',
      searchModel: 'brandSearch'
    }]
  });
}( angular.module( 'Westfield' ) ));