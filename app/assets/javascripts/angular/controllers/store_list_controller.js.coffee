((app) ->
  app.controller 'StoreListController', ['$scope', '$document', '$window', '$timeout', ( $scope, $document, $window, $timeout ) ->

    $scope.queryParams = ''
    $scope.viewingMap = false

    param = (key, val) ->
      [key, val].join('=')

    updateQueryParams = (val)->
      params = []
      params.push(param('gift_cards', true)) if $scope.gift_cards
      params.push(param('map', true)) if $scope.viewingMap
      $timeout ->
        $scope.queryParams = if params.length then '?' + params.join('&') else ''
      , 100

    $scope.saveCategory = (category) ->
      if category?
        sessionStorage.filteredCategory = category
      return true

    $scope.$watch 'gift_cards', (val) ->
      if val
        sessionStorage.giftCards = true
      else
        sessionStorage.removeItem 'giftCards'
      updateQueryParams()

  ]
) angular.module("Westfield")
