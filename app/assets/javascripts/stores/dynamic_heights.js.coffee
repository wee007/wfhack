# Used for toggling the bottom value of the stores list and store front containers
# This is done so that when the content height is less than the available height on the page,
# the container collapses and reveals more of the store map

class @DynamicHeights
  stateClass: 'is-collapsed'
  constructor: (breakpoint) ->
    @breakpoint = breakpoint
    @getElements()
    @initialise()
    $(window).resize(debounce(@initialise, 100))
  initialise: =>
    @isPluginActive = matchMedia(@breakpoint).matches
    if @isPluginActive
      @setupDefaultHeights()
      @check()

  getElements: =>
    @elements = $('.js-stores-dynamic-height')
  setupDefaultHeights: =>
    @getElements()
    debounced_check = debounce(@check, 100)
    @elements.each (i, element) =>
      element = $(element)
      element.find('img').load =>
        @_setInitialHeight(element)
        debounced_check()
      @_setInitialHeight(element)
  _setInitialHeight: (element) =>
    element.removeClass(@stateClass)
    element.data('height', element.outerHeight(true))
  check: =>
    if @isPluginActive
      # This function is slow so put it in a timeout so it doesn't block the rest of the page
      setTimeout =>
        @elements.each (i, el) =>
          element = $(el)
          # Compare original height of element to the heigh of its non hidden contents
          if element.data('height') <= element.children(':not(.hide-fully)').outerHeight(true)
            # We dont want variable height when the content is too big for the container
            element.removeClass(@stateClass)
          else
            # This sets bottom: auto;
            element.addClass(@stateClass)
      , 17