class @GlobalSearch
  inputSelector: '.js-global-search-input'
  searchStatusSelector: '.js-global-search-status'
  resultsSelector: '.js-global-search-results-container'
  constructor: ->
    @resultsUrl = "/#{westfield.centre_id}/search/dropdown"
    $ =>
      @searchStatus = $(@searchStatusSelector)
      @resultsContainer = $(@resultsSelector)
      if @googleExperimentActive()
        $('.js-global-search-form').attr('action', @switchUrlToGoogleExperiment)
    @setupEventListeners()

  makeSuggestions: (event) =>
    @searchQuery = event.target.value
    if @searchQuery != ""
      @currentIndex = -1
      @resultsContainer.load(@resultsUrl + '?search='+ encodeURI(@searchQuery), @onLoadFinish )
    else
      @onLoadFinish()

  hideSuggestions: =>
    $('.js-global-search-results').removeClass 'is-active'

  moveFocusUp: =>
    @currentIndex--
    @updateFocus()

  moveFocusDown: =>
    @currentIndex++
    @updateFocus()

  currentSelectionExists: =>
    @currentIndex != -1

  updateFocus: =>
    $results = $('.js-global-search-results-item-link')
    maxLength = $results.length - 1
    @currentIndex = 0 if @currentIndex > maxLength
    @currentIndex = maxLength if @currentIndex < 0

    $results.removeClass 'is-focused'
    $($results[@currentIndex]).addClass 'is-focused'
    @scrollSuggestions()

  scrollSuggestions: =>
    $keyboardScrollContainer = $(".js-global-search-results-keyboard-scrolling")
    containerHeight = $keyboardScrollContainer.height()
    minimumLowerPadding = 50
    minimumUpperPadding = 120
    floor = containerHeight - minimumLowerPadding
    ceiling = containerHeight - minimumUpperPadding
    $suggestion = $(".js-global-search-results-item-height .is-focused")
    bottom = $suggestion.position().top + $suggestion.height()
    current = $keyboardScrollContainer.scrollTop()
    diff = floor - bottom
    if diff < 0
      $keyboardScrollContainer.scrollTop(current - diff)
    if diff > ceiling
      $keyboardScrollContainer.scrollTop(current + (ceiling - diff))

  visitSelection: =>
    $results = $('.js-global-search-results-item-link')
    window.location.href = $($results[@currentIndex]).attr('href')

  setupEventListeners: =>
    # Listen to "input" event instead of keydown as this is trigger on clipboard paste as well as keydown
    that = this
    doc.on 'input', @inputSelector, @makeSuggestions

    # Capture esc, up arrow, down arrow and enter
    doc.on 'keydown', @inputSelector, (event) =>
      switch event.keyCode
        when 27 # Esc
          @hideSuggestions()
        when 38 # Up Arrow
          @moveFocusUp()
        when 40 # Down Arrow
          @moveFocusDown()
        when 13
          if @currentSelectionExists() # Return
            @visitSelection()
          else
            allowDefault = true
        else
          allowDefault = true
      if !allowDefault
        event.preventDefault()

    doc.click (event) =>
      unless $(event.target).parents('.js-global-search').length > 0
        @hideSuggestions()

  googleExperimentActive: ->
    westfield.google_content_experiment?

  switchUrlToGoogleExperiment: (i, url) ->
    url.replace('products?', 'search?')

  onLoadFinish: =>
    if @googleExperimentActive()
      $('.js-global-search-dummy-search').attr('href', @switchUrlToGoogleExperiment)

    $dropdownCountContainer = $('.js-global-search-dropdown-count')
    numberOfResults = parseInt($dropdownCountContainer.attr('data-count'), 10)
    statusText = ''
    if $dropdownCountContainer && numberOfResults && @searchQuery != ''
      $('.js-global-search-results').addClass 'is-active'
      if numberOfResults == 1
        statusText = "#{numberOfResults} result is"
      else
        statusText = "#{numberOfResults} results are"
      statusText += ' available, use up and down arrow keys to navigate.'
    else
      @hideSuggestions()
      statusText = ''
    @searchStatus.html(statusText)

new GlobalSearch()


