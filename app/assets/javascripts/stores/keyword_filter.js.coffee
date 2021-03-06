#= require jquery-extensions/jquery.fastLiveFilter
#= require support/debounce
#= require stores/list_position

class @StoresKeywordFilter

  constructor: (map, callback) ->

    @map = map

    @callback = callback

    @setupToggleListPosition()

  setupToggleListPosition: =>
     @listPositioner = new StoresListPosition

  filterStoreLetterHeadings: (stores, numShown) =>
    firstLetter = ''
    visibleLetterHeadings = []
    previousFirstLetter = ''

    $.each stores, (i, store)->
      if not store.hidden
        firstLetter = store.text.substr(0, 1).toLowerCase()
        if not isNaN firstLetter
          firstLetter = '#'

        if previousFirstLetter isnt firstLetter
          visibleLetterHeadings.push(firstLetter)
          previousFirstLetter = firstLetter

    @storeListLetters.each (i, el) ->
      heading = $(el)
      letter = $.trim(heading.text()).toLowerCase()
      if letter in visibleLetterHeadings
        heading.removeClass('hide-fully')
      else
        heading.addClass('hide-fully')

  filterMapPins: (stores, numShown) =>
    # Only show pins if there is a keyword or category filter applied
    if numShown < stores.length or westfield.filtering_by_category
      @pinFilteredStores()
    else
      storeMapPage.map.clearPins?('pins')
      storeMapPage.map.clearLevelCounts?()

  showStoreLogos: ->
    $('.js-defer-image-load-container').data('DeferredImages')?.loadVisibleImages();

  # Determines how stores will be matched with keyword
  filterStores: (filter, fullText) =>
    matches = false
    if filter.length == 1
      return fullText.substr(0, 1) == filter

    if filter.indexOf(' ') >= 0
      return fullText.indexOf(filter) == 0

    $.each fullText.split(' '), (i, word) ->
      if word.indexOf(filter) == 0
        matches = true

    return matches

  updateNumberOfFilteredStores: (numShown) =>
    @numberOfFilteredStores.text(numShown)
    keyword = @filterInput.val()
    supplementFilterDescription = ''
    if numShown == 0
      unless @postFilterCount.hasClass("hide-fully")
        @postFilterCount.addClass("hide-fully")
        @listPositioner.setListPosition()
    else
      if @postFilterCount.hasClass("hide-fully")
        @postFilterCount.removeClass("hide-fully")
        @listPositioner._setListPosition()

      if keyword == ''
        supplementFilterDescription = 'found'
      else if keyword.length == 1
        supplementFilterDescription = "starting with '#{keyword}' found"
      else
        supplementFilterDescription = "matching '#{keyword}' found"

      @filterDescriptionSupplement.text supplementFilterDescription

  setupKeywordFilter: =>
    @storeListLetters = $('.js-stores-keyword-filter-letter')
    @numberOfFilteredStores = $('.js-stores-keyword-filter-number-of-filtered-stores')
    @filterDescriptionSupplement = $('.js-stores-keyword-filter-description-supplement')
    @filterInput = $('.js-stores-keyword-filter-input')
    @postFilterCount = $('.js-stores-keyword-filter-post-filter-count')

    # These functions are slow, so debounce them so they dont lock up the browser
    delayedFilterMapPins = debounce(@filterMapPins, 400)
    delayedShowStoreLogos = debounce(@showStoreLogos, 400)
    @noStoresMatchingMessage = $('.js-stores-keyword-filter-no-results')

    $('.js-stores-keyword-filter-input').fastLiveFilter '.js-stores-keyword-filter-list',
      selector: '.js-stores-keyword-filter-store-name',
      # Need a small timeout because of race condition on mobile
      timeout: 50,
      filterFunction: @filterStores
      callback: (stores, numShown)=>
        @filterStoreLetterHeadings(stores, numShown)
        delayedFilterMapPins(stores, numShown)
        delayedShowStoreLogos()
        @handleNoStoresInList(numShown)
        @updateNumberOfFilteredStores(numShown)
        @callback()

  handleNoStoresInList: (numShown) =>
    if numShown == 0
      @noStoresMatchingMessage.removeClass('hide-fully')
      @noStoresMatchingMessage.find('.js-stores-keyword-filter-value').html('\"'+$('.js-stores-keyword-filter-input').val()+'\"')
    else
      @noStoresMatchingMessage.addClass('hide-fully')

  pinFilteredStores: ->
    getId = -> $(@).data 'store-id'
    ids = $('.js-stores-keyword-filter-store:not(.hide-fully) [data-store-id]').map getId
    @map.pinStores(ids, true)