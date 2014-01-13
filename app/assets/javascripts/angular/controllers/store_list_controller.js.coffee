((app) ->
  app.controller 'StoreListController', ['$scope', '$document', '$window',  ( $scope, $document, $window ) ->
    $scope.viewingSubCategory = undefined
    $scope.viewSubCategory = (category) -> $scope.viewingSubCategory = category

    $scope.saveCategory = (category) ->
      if Modernizr.localstorage and
          category?
        localStorage.filteredCategory = category

    # Gift card submit
    $scope.giftCardSubmit = -> $window.giftCardForm.submit()

    # Clicking outside will unselect category
    $document.bind 'click', -> $scope.viewSubCategory(null)

    # Escape key will unselect category
    $document.bind 'keydown', (event) ->
      $scope.viewSubCategory(null) if event.keyCode == 27
  ]
) angular.module("Westfield")
