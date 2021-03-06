class @GlobalSearch
  selectors:
    globalSearch: '.js-global-search'
    input: '.js-global-search-input'
    searchStatus: '.js-global-search-status'
    results: '.js-global-search-results'
    resultsInner: '.js-global-search-results-inner'
    resultsItem: '.js-global-search-results-item-link'
    resultsItemFocused: '.js-global-search-results-item-height .is-focused'
    dummyResult: '.js-global-search-dummy-search'
    form: '.js-global-search-form'
  constructor: ->
    @resultsUrl = "/#{westfield.centre_id}/search/dropdown"
    $ =>
      @searchStatus = $(@selectors.searchStatus)
      @results = $(@selectors.results)
      @resultsInner = $(@selectors.resultsInner)
      if @googleExperimentActive()
        $(@selectors.form).attr('action', @switchUrlToGoogleExperiment)
    @setupEventListeners()

  makeSuggestions: (event) =>
    @searchQuery = event.target.value
    if @searchQuery != ""
      @currentIndex = -1
      @resultsInner.load(@resultsUrl + '?search='+ encodeURI(@searchQuery), @onLoadFinish )
    else
      @onLoadFinish()

  hideSuggestions: =>
    @results.removeClass 'is-active'

  moveFocusUp: =>
    @currentIndex--
    @updateFocus()

  moveFocusDown: =>
    @currentIndex++
    @updateFocus()

  currentSelectionExists: =>
    @currentIndex != -1

  updateFocus: =>
    $results = $(@selectors.resultsItem)
    maxLength = $results.length - 1
    @currentIndex = 0 if @currentIndex > maxLength
    @currentIndex = maxLength if @currentIndex < 0

    $results.removeClass 'is-focused'
    $($results[@currentIndex]).addClass 'is-focused'
    @scrollSuggestions()

  scrollSuggestions: =>
    $keyboardScrollContainer = @resultsInner
    containerHeight = $keyboardScrollContainer.height()
    minimumLowerPadding = 50
    minimumUpperPadding = 120
    floor = containerHeight - minimumLowerPadding
    ceiling = containerHeight - minimumUpperPadding
    $suggestion = $(@selectors.resultsItemFocused)
    bottom = $suggestion.position().top + $suggestion.height()
    current = $keyboardScrollContainer.scrollTop()
    diff = floor - bottom
    if diff < 0
      $keyboardScrollContainer.scrollTop(current - diff)
    if diff > ceiling
      $keyboardScrollContainer.scrollTop(current + (ceiling - diff))

  visitSelection: =>
    $results = $(@selectors.resultsItem)
    window.location.href = $($results[@currentIndex]).attr('href')

  setupEventListeners: =>
    # Listen to "input" event instead of keydown as this is trigger on clipboard paste as well as keydown
    doc.on 'input', @selectors.input, @makeSuggestions

    # Capture esc, up arrow, down arrow and enter
    doc.on 'keydown', @selectors.input, (event) =>
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
      unless $(event.target).parents(@selectors.globalSearch).length > 0
        @hideSuggestions()

  googleExperimentActive: ->
    westfield.google_content_experiment?

  switchUrlToGoogleExperiment: (i, url) ->
    url.replace('products?', 'search?')

  onLoadFinish: =>
    if @googleExperimentActive()
      $(@selectors.dummyResult).attr('href', @switchUrlToGoogleExperiment)

    statusText = ''
    if @numberOfResults && @searchQuery != ''
      @results.addClass 'is-active'
      if @numberOfResults == 1
        statusText = "#{@numberOfResults} result is"
      else
        statusText = "#{@numberOfResults} results are"
      statusText += ' available, use up and down arrow keys to navigate.'
    else
      @hideSuggestions()
      statusText = ''
    @searchStatus.html(statusText)

@globalSearch = new GlobalSearch()