((app) ->
  app.controller 'StoreListController', ['$scope', '$document', '$window',  ( $scope, $document, $window ) ->
    $scope.viewingSubCategory = undefined
    $scope.viewSubCategory = (category) -> $scope.viewingSubCategory = category
    $scope.queryParams = ''
    $scope.viewingMap = false
    
    param = (key, val) ->
      [key, val].join('=')
    
    updateQueryParams = ->
      params = []
      params.push(param('gift_cards', true)) if $scope.gift_cards
      params.push(param('map', true)) if $scope.viewingMap
      $scope.queryParams = if params.length then '?' + params.join('&') else ''

    $scope.saveCategory = (category) ->
      if Modernizr.localstorage and
          category?
        localStorage.filteredCategory = category
      return true

    $scope.$watch 'gift_cards', (val) ->
      if Modernizr.localstorage
        if val
          localStorage.giftCards = true
        else
          localStorage.removeItem 'giftCards'
      updateQueryParams()

    $scope.$watch('viewingMap', updateQueryParams)

    # Gift card submit
    $scope.giftCardChange = ->
      $(':submit', $window.giftCardForm).click()
      @

    # Clicking outside will unselect category
    $document.bind 'click', -> $scope.viewSubCategory(null)

    # Escape key will unselect category
    $document.bind 'keydown', (event) ->
      $scope.viewSubCategory(null) if event.keyCode == 27
  ]
) angular.module("Westfield")
