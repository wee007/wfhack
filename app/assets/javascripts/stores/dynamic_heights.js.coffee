# Used for toggling the bottom value

class @DynamicHeights
  constructor: ->
    @elements = $(".js-dynamic-height")
    @initialise()
    $(window).resize(debounce(@initialise, 100))
  initialise: =>
    @setupDefaultHeights()
    @check()
  setupDefaultHeights: =>
    @elements.each (i, element) ->
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