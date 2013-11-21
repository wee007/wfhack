((app) ->
  app.controller "GlobalSearchCtrl", ['$scope', '$window', 'SuggestionsBuilder', 'GlobalSearch', ($scope, $window, SuggestionsBuilder, GlobalSearch) ->
    $scope.search = GlobalSearch
    $scope.searchQuery = ""
    $scope.suggestionsVisible = false

    $scope.focusedSuggestion = undefined

    highlightedClass = 'is-focused'

    # When there are search results, collect them as suggestions & display
    GlobalSearch.onChange ->
      $scope.suggestions = didYouMean()
      $scope.showSuggestions()

    didYouMean = ->
      SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.search.results)

    combinedResults = ->
      suggestions = []
      suggestions = suggestions.concat($scope.suggestions.stores) if $scope.suggestions.stores
      suggestions = suggestions.concat($scope.suggestions.products) if $scope.suggestions.products

      suggestions

    highlightSuggestion = (direction) ->
      suggestions = combinedResults()

      # Get the current index, or zero
      index = suggestions.indexOf( $scope.focusedSuggestion ) || 0

      maxLength = suggestions.length - 1
      index-- if direction == 'prev'
      index++ if direction == 'next'
      index = 0 if index > maxLength
      index = maxLength if index < 0

      $scope.focusedSuggestion = suggestions[index]

    # Search result text for screen readers
    $scope.searchResultText = ->
      'one': "Press enter to search for products."
      'other':  "#{$scope.suggestions.count} results are available, use up and down arrow keys to navigate."

    $scope.showSuggestions = -> $scope.suggestionsVisible = true
    $scope.hideSuggestions = -> $scope.suggestionsVisible = false

    $scope.makeSuggestions = (event) ->
      if event
        # Arrow keys should not invoke a ajax request
        return if event.keyCode == 38 || event.keyCode == 40

        # Hide suggestions when escape is pressed
        $scope.hideSuggestions() if event and event.keyCode == 27

      if $scope.searchQuery && $scope.searchQuery != ""
        GlobalSearch.get term: $scope.searchQuery, centre: $scope.centre_id

    $scope.navigateSuggestions = (event) ->
      switch event.keyCode
        when 38 # up
          highlightSuggestion('prev')
          event.preventDefault()
        when 40 # down
          highlightSuggestion('next')
          event.preventDefault()
        when 13 # enter
          $window.location = $scope.url($scope.focusedSuggestion)
          event.preventDefault()

      $scope.url = (suggestion) -> "/#{$scope.centre_id}#{suggestion.url}"

  ]
) angular.module("Westfield")