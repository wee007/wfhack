class @StoresListPosition
  constructor: ->
    @setListPosition = debounce(@_setListPosition, 100)
    $ =>
      $(window).resize(@setListPosition)
      @_setListPosition()

  _setListPosition: =>
    container = $('.js-stores-list-position-container')
    filtersContainer = $('.js-stores-list-position-filter-container')
    storesList = $('.js-stores-list-position-store-list')
    twoColumnView = $('body').width() >= 1024
    listTop = filtersContainer.outerHeight(twoColumnView)

    # TODO dont hard code 21, get the line height from CSS
    listTop += 21 if twoColumnView
    storesList.css('top', "#{listTop}px")