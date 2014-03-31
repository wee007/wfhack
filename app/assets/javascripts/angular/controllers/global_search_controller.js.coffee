((app) ->
  app.controller "GlobalSearchCtrl", ['$scope', '$window', '$timeout', 'SuggestionsBuilder', 'GlobalSearch', ($scope, $window, $timeout, SuggestionsBuilder, GlobalSearch) ->
    $scope.search = GlobalSearch
    $scope.searchQuery = ""
    $scope.suggestionsVisible = false

    $scope.focusedSuggestion = undefined

    highlightedClass = 'is-focused'

    # Close the search suggestions dropdown if the user clicks outside the dropdown
    $(document).click (event) ->
      unless $(event.target).parents('.js-global-search').length > 0
        $scope.hideSuggestions() if $scope.suggestionsVisible

    $('.js-global-search').on 'toggle-visibility.close', ->
      $scope.searchQuery = ''
      $scope.hideSuggestions()

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

    scrollSuggestions = (index,direction,maxLength) ->
      lowerThreshold = 7
      upperThreshold = maxLength - lowerThreshold
      elementHeight = $(".js-search-results-item-height").height();
      $el = $(".js-search-results-keyboard-scrolling")
      current = $el.scrollTop()
      if direction == 'prev' && index < upperThreshold
        $el.scrollTop(current - elementHeight)
      if direction == 'next' && index > lowerThreshold
        $el.scrollTop(current + elementHeight)
      if  direction == 'next' && index == 0 
        $el.scrollTop(0)
      if  direction == 'prev' && index == maxLength
        $el.scrollTop(999999)

    highlightSuggestion = (direction) ->
      suggestions = combinedResults()

      # Get the current index, or zero
      index = suggestions.indexOf( $scope.focusedSuggestion ) || 0

      maxLength = suggestions.length - 1
      index-- if direction == 'prev'
      index++ if direction == 'next'
      index = 0 if index > maxLength
      index = maxLength if index < 0
      scrollSuggestions(index, direction, maxLength)
      $scope.focusedSuggestion = suggestions[index]

    # Search result text for screen readers
    $scope.searchResultText = ->
      'one': "Press enter to search for products."
      'other':  "#{$scope.suggestions.count} results are available, use up and down arrow keys to navigate."

    $scope.showSuggestions = -> $scope.suggestionsVisible = true
    $scope.hideSuggestions = ->
      $timeout (-> $scope.suggestionsVisible = false), 250

    $scope.makeSuggestions = (event) ->
      if event
        # Arrow keys should not invoke a ajax request
        return if event.keyCode == 38 || event.keyCode == 40

        # Hide suggestions when escape is pressed
        $scope.hideSuggestions() if event and event.keyCode == 27

      if $scope.searchQuery && $scope.searchQuery.length > 1
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
          if $scope.focusedSuggestion
            $window.location = $scope.url($scope.focusedSuggestion, 'enter')
            event.preventDefault()

      $scope.url = (suggestion, searchSource = 'dropdown') ->
        #If there is already a query string, no need for '?'
        urlJoiner = if suggestion.url.indexOf("?") > 0 then "&" else "?"

        # Construct the full suggestion URL. 'search_source' is purely for analytics purposes.
        url = "/#{$scope.centre_id}#{suggestion.url}#{urlJoiner}search_source=#{searchSource}&search_keyword=#{$scope.searchQuery}"

      $scope.submit = ( event ) ->
        suggestions = $scope.suggestions.products
        suggestion = suggestions[suggestions.length-1]

        $window.location = $scope.url(suggestion, 'enter')
        event.preventDefault()

  ]
) angular.module("Westfield")