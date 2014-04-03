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
      SuggestionsBuilder.didYouMean($scope.searchQuery, $scope.search.results, $scope.centre_id)

    combinedResults = ->
      suggestions = []
      for key in $scope.sortOrderTypes
        result = $scope.suggestions[key]
        suggestions = suggestions.concat(result) if result
      suggestions

    scrollSuggestions = ->
      containerHeight = $(".js-search-results-keyboard-scrolling").height()
      minimumLowerPadding = 50
      minimumUpperPadding = 120
      floor = containerHeight - minimumLowerPadding
      ceiling = containerHeight - minimumUpperPadding
      $suggestion = $(".js-search-results-item-height .is-focused")
      bottom = $suggestion.position().top + $suggestion.height()
      $el = $(".js-search-results-keyboard-scrolling")
      current = $el.scrollTop()
      diff = floor - bottom
      if diff < 0
        $el.scrollTop(current - diff)
      if diff > ceiling
        $el.scrollTop(current + (ceiling - diff))

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

      # We need to let the render cycle finish
      setTimeout(scrollSuggestions, 0);

    $scope.sortOrderTypes =
      [
        'centre_services'
        'centre_information'
        'stores'
        'products'
        'deals'
        'events'
      ]

    $scope.iconMapping = (type) ->
      suffix = type
      suffix = 'info' if type == "centre_information" 
      suffix = 'info' if type == "centre_services"
      suffix = 'store' if type == "stores"
      return 'icon--' + suffix

    $scope.unsnake = (name) ->
      str = name.replace("_", " ")
      return `str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});`

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
        url = "#{suggestion.url}#{urlJoiner}search_source=#{searchSource}&search_keyword=#{$scope.searchQuery}"

      $scope.submit = ( event ) ->
        suggestions = $scope.suggestions.products
        suggestion = suggestions[suggestions.length-1]

        $window.location = $scope.url(suggestion, 'enter')
        event.preventDefault()

  ]
) angular.module("Westfield")