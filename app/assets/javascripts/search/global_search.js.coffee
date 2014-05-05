class @GlobalSearch
  inputSelector: '.js-global-search-input'
  resultsSelector: '.js-global-search-results'
  resultsUrl: '/sydney/search/dropdown'

  constructor: ->
    @setupEventListeners()

  makeSuggestions: (searchQuery) =>
    if searchQuery != ""
      @currentIndex = -1
      $(@resultsSelector).load(@resultsUrl + '?search='+ encodeURI(searchQuery), @updateVisibility )

  hideSuggestions: =>
    $('.search-results').addClass 'hide-visually'

  moveFocusUp: =>
    @currentIndex--
    @updateFocus()

  moveFocusDown: =>
    @currentIndex++
    @updateFocus()

  updateFocus: =>
    $results = $('.js-search-results-item-height a')
    maxLength = $results.length - 1
    @currentIndex = 0 if @currentIndex > maxLength
    @currentIndex = maxLength if @currentIndex < 0
    
    $results.removeClass 'is-focused'
    $($results[@currentIndex]).addClass 'is-focused'
    @scrollSuggestions()

  scrollSuggestions: =>
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

  visitSelection: =>
    $results = $('.js-search-results-item-height a')
    window.location.href = $($results[@currentIndex]).attr('href')

  setupEventListeners: =>
    # Listen to "input" event instead of keydown as this is trigger on clipboard paste as well as keydown
    that = this
    $(document).on 'input', @inputSelector, (event) ->
      that.makeSuggestions $(@).val()

    # Capture esc, up arrow, and down arrow 
    $(document).on 'keydown', @inputSelector, (event) =>
      switch event.keyCode
        when 27 # Esc
          @hideSuggestions()
        when 38 # Up Arrow
          @moveFocusUp()
        when 40 # Down Arrow
          @moveFocusDown()
        when 13 # Down Arrow
          @visitSelection()
        else
          allowDefault = true
      if !allowDefault
        event.preventDefault()

    $(document).click (event) =>
      unless $(event.target).parents('.js-global-search').length > 0
        @hideSuggestions()

  updateVisibility: =>


    if $('.js-dropdown-count') && $('.js-dropdown-count').attr('data-count') != "0"
      $('.search-results').removeClass 'hide-visually'
      $('.js-status').html("#{$('.js-dropdown-count').attr('data-count')} results are available, use up and down arrow keys to navigate.")
    else
      @hideSuggestions()
      $('.js-status').html("Press enter to search for products.")

new GlobalSearch()


