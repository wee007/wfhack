# Used for toggling the bottom value of the stores list and store front containers
# This is done so that when the content height is less than the available height on the page,
# the container collapses and reveals more of the store map

class @DynamicHeights
  stateClass: 'is-collapsed'
  constructor: ->
    @getElements()
    @initialise()
    $(window).resize(debounce(@initialise, 500))
  initialise: =>
    @setupDefaultHeights()
    @check()
  getElements: =>
    @elements = $('.js-stores-dynamic-height')
  setupDefaultHeights: =>
    @getElements()
    @elements.each (i, element) =>
      $(element).removeClass(@stateClass)
      $(element).data('height', $(element).outerHeight(true))
  check: =>
    @elements.each (i, el) =>
      element = $(el)
      # Compare original height of element to the heigh of its non hidden contents
      if element.data('height') <= element.children(':not(.hide-fully)').outerHeight(true)
        # We dont want variable height when the content is too big for the container
        element.removeClass(@stateClass)
      else
        # This sets bottom: auto;
        element.addClass(@stateClass)