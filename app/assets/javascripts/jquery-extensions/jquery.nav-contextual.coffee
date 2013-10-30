# Used for horizontal responsive navs.
# @desc used to apply horizontal scroll bars for horizontal lists
# @initialise  $('.js-nav-contextual').navContextual();

$.fn.navContextual = (options) ->
  settings = $.extend {
    # defaults
    isClippedClass: 'is-clipped'
    listSelector: '.js-nav-contextual-list'
    clipOverlaySelector: '.js-nav-contextual-clip-overlay'
  }, options

  resize = =>
    list = @find settings.listSelector
    # Add the clip width by default.
    listWidth = (@find(settings.clipOverlaySelector).outerWidth(true) / 2) / 2
    list.children().each (n, child) ->
      listWidth = listWidth + $(child).outerWidth(true)

    if @width() < listWidth
      @addClass settings.isClippedClass
      list.css width: listWidth
    else
      @removeClass settings.isClippedClass

  resize() # Run for the 1st time.

  $(window).on 'resize', =>
    clearTimeout @timeout if @timeout
    @timeout = setTimeout resize, 100

  @ # Return @/this so you can chain.