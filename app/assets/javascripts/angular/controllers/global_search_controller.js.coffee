((app) ->
  app.controller "GlobalSearchCtrl", ['$scope', '$element', '$window', 'SuggestionsBuilder', 'GlobalSearch', ($scope, $element, $window, SuggestionsBuilder, GlobalSearch) ->
    $scope.search = GlobalSearch
    $scope.searchQuery = ""
    $scope.suggestionsVisible = false

    highlightedItem = -1
    highlightedClass = 'is-active'
    $suggestionsList = angular.element('.search-results__list')

    # When there are search results, collect them as suggestions & display
    GlobalSearch.onChange ->
      $scope.suggestions = didYouMean()
      $scope.showSuggestions()

    didYouMean = ->
      SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.search.results)

    highlightSuggestion = (direction) ->
      $links = $suggestionsList.find('a')

      $suggestionsList.find("." + highlightedClass).removeClass(highlightedClass)

      highlightedItem-- if direction == 'prev'
      highlightedItem++ if direction == 'next'

      # Don't allow the numbers to cycle through above or below the amount of items
      highlightedItem = 0 if highlightedItem > ($links.length - 1)
      highlightedItem = $links.length - 1 if highlightedItem < 0

      # Highlight the new item
      $links.filter(":eq(#{highlightedItem})").addClass(highlightedClass)

    # Search result text for screen readers
    $scope.searchResultText = ->
      'one': "Press enter to search for products."
      'other': $scope.suggestions.length + " results are available, use up and down arrow keys to navigate."

    $scope.showSuggestions = -> $scope.suggestionsVisible = true
    $scope.hideSuggestions = ->
      $window.setTimeout (->
        $scope.$apply -> $scope.suggestionsVisible = false
      ), 500

    $scope.makeSuggestions = (event) ->
      # Hide suggestions when escape is pressed
      $scope.hideSuggestions() if event and event.keyCode == 27

      if $scope.searchQuery && $scope.searchQuery != ""
        GlobalSearch.get {term: $scope.searchQuery}

    $scope.navigateSuggestions = (event) ->
      switch event.keyCode
        when 38 # up
          event.preventDefault()
          highlightSuggestion('prev')
        when 40 # down
          event.preventDefault()
          highlightSuggestion('next')
        when 13 # enter
          location = $suggestionsList.find('.' + highlightedClass).attr('href')
          unless location == undefined
            event.preventDefault()
            $window.location = location

  ]
) angular.module("Westfield")