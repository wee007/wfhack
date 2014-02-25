#= require jquery-extensions/jquery.fastLiveFilter.js.coffee
#= require underscore/underscore

class @StoresKeywordFilter

  constructor: (map) ->

    @map = map

    @setListPosition = _.debounce(@_setListPosition, 100)
    $(window).resize(@setListPosition)
    @setListPosition()

    @setupKeywordFilter()

    $('.js-stores-keyword-filter-toggle').click =>
      @setListPosition()

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
      storeMapPage.map.clearPins?(true)
      storeMapPage.map.clearLevelCounts?()

  showStoreLogos: ->
    $('.js-defer-image-load-container').data('DeferredImages')?.loadVisibleImages();

  # Determines how stores will be matched with keyword
  filterStores: (filter, fullText) =>
    matches = false
    if filter.indexOf(' ') >= 0
      return fullText.indexOf(filter) == 0

    $.each fullText.split(' '), (i, word) ->
      if word.indexOf(filter) == 0
        matches = true

    return matches

  setupKeywordFilter: =>
    @storeListLetters = $('.js-stores-letter')

    # These functions are slow, so debounce them so they dont lock up the browser
    delayedFilterMapPins = _.debounce(@filterMapPins, 400)
    delayedShowStoreLogos = _.debounce(@showStoreLogos, 400)

    $('.js-stores-keyword-filter').fastLiveFilter '.js-keyword-filter-list',
      selector: 'a:first',
      timeout: 0,
      filterFunction: @filterStores
      callback: (stores, numShown)=>
        @filterStoreLetterHeadings(stores, numShown)
        delayedFilterMapPins(stores, numShown)
        delayedShowStoreLogos()


  _setListPosition: =>
    container = $('.js-stores-maps-toggle-wrap')
    filtersContainer = $('.js-stores-filters')
    storesList = $('.js-store-list-position')
    twoColumnView = $('body').width() > 1024
    listTop = filtersContainer.outerHeight(twoColumnView)

    # TODO dont hard code 21, get the line height from CSS
    listTop += 21 if twoColumnView
    storesList.css('top', "#{listTop}px")

  pinFilteredStores: ->
    getId = -> $(@).data 'store-id'
    ids = $('dd:not(.hide-fully) a[data-store-id]').map getId
    @map.pinStores(ids, true)