((app) ->
  app.controller "GlobalSearchCtrl", ['$scope', '$window', '$element', 'SuggestionsBuilder', 'GlobalSearch', ($scope, $window, $element, SuggestionsBuilder, GlobalSearch) ->
    $scope.search = GlobalSearch
    $scope.searchQuery = ""
    highlightedItem = -1
    highlightedClass = 'is-active'
    $suggestionsList = angular.element('.search-results__list')

    # Clicking anywhere on the screen should close the suggestions list if its open
    angular.element($window).bind 'click', ->
      if angular.isArray($scope.suggestions)
        $scope.$apply -> $scope.suggestions = []

    GlobalSearch.onChange ->
      $scope.suggestions = didYouMean()

    didYouMean = ->
      SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.search.results)

    highlightSuggestion = (direction) ->
      $suggestionsList.find("." + highlightedClass).removeClass(highlightedClass)

      highlightedItem-- if direction == 'prev'
      highlightedItem++ if direction == 'next'

      # Don't allow the numbers to cycle through above or below the amount of items
      highlightedItem = 0 if highlightedItem < 0 or highlightedItem > ($suggestionsList.find('a').length - 1)

      # Highlight the new item
      $suggestionsList.find("a:eq(#{highlightedItem})").addClass(highlightedClass)

    # Search result text for screen readers
    $scope.searchResultText = ->
      'one': "Press enter to search for products."
      'other': $scope.suggestions.length + " results are available, use up and down arrow keys to navigate."

    $scope.makeSuggestions = ->
      if $scope.searchQuery && $scope.searchQuery != ""
        GlobalSearch.get {term: $scope.searchQuery}
      else
        $scope.suggestions = didYouMean()

    $scope.navigateSuggestions = (event) ->
      switch event.keyCode
        when 27 # escape
          $scope.suggestions = []
          highlightedItem = -1
          angular.element('#global-search').focus()
        when 38 # up
          event.preventDefault()
          highlightSuggestion('prev')
        when 40 # down
          event.preventDefault()
          highlightSuggestion('next')
        when 13 # enter
          event.preventDefault()
          $window.location = $suggestionsList.find('.' + highlightedClass).attr('href')
  ]
) angular.module("Westfield")