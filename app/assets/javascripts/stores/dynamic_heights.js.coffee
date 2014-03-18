class @DynamicHeights
  constructor: ->
    @elements = $(".js-dynamic-height")
    @setupDefaultHeights()
    @check()
    $(window).resize(debounce(=>
      @setupDefaultHeights()
      @check()
    , 100))
  setupDefaultHeights: =>
    @elements.each (i, element) ->
      $(element).data('height', $(element).outerHeight(true))
      $(element).data('bottom', $(element).css('bottom'))
  check: =>
    @elements.each (i, el) ->
      element = $(el)
      if element.data('height') <= element.children(':not(.hide-fully)').outerHeight(true)
        # There is a scroll bar
        $(element).css('bottom', $(element).data('bottom'))
      else
        $(element).css('bottom', 'auto')

    console.timeEnd("a")