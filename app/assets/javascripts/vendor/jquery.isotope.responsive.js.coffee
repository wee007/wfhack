$.Isotope.prototype._responsive = ->

  if @options.responsive

    calculateCols = (cols) =>
      pinboardWidth = @element.width() + @options.responsive.gutter
      columnWidth = pinboardWidth / cols
      tileWidth = columnWidth - @options.responsive.gutter

      # Call its self again (and again) to find the optimal col vs col width
      # solution
      if tileWidth < @options.responsive.minItemSize &&
        cols > @options.responsive.minNumberOfColumn
       return calculateCols cols - 1

      @masonry.cols = cols
      @masonry.columnWidth = columnWidth
      @masonry.gutterWidth = @options.responsive.gutter
      $(@options.itemSelector).width tileWidth

    calculateCols @options.responsive.maxNumberOfColumn

# HACK
# This fixes the wrong with calulation that @element.width() returns
$.Isotope.prototype._widthFix = ->
  if @options.widthFix
    # Cache the element width so we can check that the calucations were correct
    @.elementWidth = @element.width()

    @options.onLayout = ($elems, instance) ->
      # Check the elements width, if its diffrent relayout as it should be the same.
      if @width() != instance.elementWidth
        # Timeout is needed so it happens lasts
        setTimeout (=> @isotope('reLayout')), 0

$.Isotope.prototype._masonryReset = ->
  # layout-specific props
  @masonry = {}
  @_widthFix()
  @_responsive()
  i = @masonry.cols
  @masonry.colYs = []
  while (i--)
    @masonry.colYs.push( 0 )

$.Isotope.prototype._masonryResizeChanged = ->
   @_widthFix()
   @_responsive()
   true # Always true as the cols are dynamic