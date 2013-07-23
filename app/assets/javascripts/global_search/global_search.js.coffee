app = angular.module("Westfield", [])

app.controller "GlobalSearchCtrl", ($scope) ->
  $scope.searchQuery = null
  $scope.searchResults = {}

  $scope.$watch 'searchQuery', ->
    if $scope.searchQuery && $scope.searchQuery != ""
      $scope.search()
    else
      $scope.searchResults = {}

  $scope.didYouMean = ->
    results = []
    angular.forEach $scope.searchResults['results'], (searchResult)->
      result = {}
      angular.forEach searchResult, (value,key)->
        result[value['data']['param_name']] ||= []
        result[value['data']['param_name']].push({display: value['data']['display'], value: value['data']['param_value']})
      description = ""
      if result['colour']
        window.colour = result['colour']
        length = result['colour'].length
        angular.forEach result['colour'], (item, ind)->
          console.debug(ind, length, length - 1, item)
          description += item['display']
          if ind < (length - 2)
            description += ', '
          else if ind < (length - 1)
            description += ' or '
      description += " products"
      if result['retailer']
        description += ' from '
        length = result['retailer'].length
        angular.forEach result['retailer'], (item, ind)->
          description += item['display']
          if ind < (length - 2)
            description += ', '
          else if ind < (length - 1)
            description += ' or '
      result['description'] = description
      results.push(result)
    results

  $scope.search = ->
    url = "/api/search/master/search.json" +
      "?term=" + $scope.searchQuery
    $.ajax
      type: "GET"
      dataType: "json"
      contentType: "application/json; charset=utf-8"
      url: url
      success: (data) ->
        $scope.$apply ->
          $scope.searchResults = data

