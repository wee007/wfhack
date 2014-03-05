class @StoresListPosition
  constructor: ->
    @setListPosition = debounce(@_setListPosition, 100)
    $ =>
      @body = $(window)
      @filtersContainer = $('.js-stores-list-position-filter-container')
      @storesList = $('.js-stores-list-position-store-list')
      $(window).resize(@setListPosition)
      @_setListPosition()
      $('[toggle-visibility]').click =>
        @_setListPosition()

  _setListPosition: =>
    listMapViewCombined = window.innerWidth >= 1024
    listTop = @filtersContainer.outerHeight(listMapViewCombined)

    # TODO dont hard code 21, get the line height from CSS
    listTop += 21 if listMapViewCombined
    @storesList.css('top', "#{listTop}px")
