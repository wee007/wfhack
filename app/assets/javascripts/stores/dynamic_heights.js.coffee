# Used for toggling the bottom value

class @DynamicHeights
  constructor: ->
    @getElements()
    @initialise()
    $(window).resize(debounce(@initialise, 500))
  initialise: =>
    @setupDefaultHeights()
    @check()
  getElements: =>
    @elements = $(".js-dynamic-height")
  setupDefaultHeights: =>
    @getElements()
    @elements.each (i, element) ->
      $(element).removeClass('is-variable-height')
      $(element).data('height', $(element).outerHeight(true))
  check: =>
    @elements.each (i, el) ->
      element = $(el)
      # Compare original height of element to the heigh of its non hidden contents
      if element.data('height') <= element.children(':not(.hide-fully)').outerHeight(true)
        # We dont want variable height when the content is too big for the container
        element.removeClass('is-variable-height')
      else
        # This sets bottom: auto;
        element.addClass('is-variable-height')