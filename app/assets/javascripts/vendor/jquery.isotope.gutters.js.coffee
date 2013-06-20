$.Isotope.prototype._getMasonryAutoGutters = ->

  @masonry.columnWidth = @options.masonry && @options.masonry.columnWidth ||
                # or use the size of the first item
                @$filteredAtoms.outerWidth(true) ||
                # if there's no items, use size of container
                @element.width()

  if @options.autoGutters
    cols = Math.max Math.floor(@element.width() / @masonry.columnWidth), 1
    gutter = (@element.width() - (cols * @masonry.columnWidth)) / (cols - 1)
    @masonry.columnWidth += gutter
  else
    gutter = 0

  @masonry.cols = Math.floor (@element.width() + gutter) / @masonry.columnWidth
  @masonry.cols = Math.max @masonry.cols, 1


$.Isotope.prototype._masonryReset = ->
  # layout-specific props
  @masonry = {}
  # FIXME shouldn't have to call this again
  @_getMasonryAutoGutters()
  i = @masonry.cols
  @masonry.colYs = []
  while (i--)
    @masonry.colYs.push( 0 )

$.Isotope.prototype._masonryResizeChanged = ->
   @_getMasonryAutoGutters()
   true # Always true as the gutters are dynamic