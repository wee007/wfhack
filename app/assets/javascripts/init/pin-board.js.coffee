class @PinBoard

  colTypes:
    2: 'half',
    3: 'third',
    4: 'quarter',
    5: 'fifth',
    6: 'sixth'

  constructor: (@pinBoardSelector) ->
    # Clone the items as they are removed, and added between breakpoints
    @items = $("#{@pinBoardSelector} .js-tile").clone()
    debugger
    # The palm is default, since we are mobile 1st.
    @currentNumberOfCols = 2

  build: ->

    mediaQueries = {
      palm: "all and (max-width: 40em)", # 0-640px
      smallLap: "all and (min-width: 40.0625em) and (max-width: 56.25em)", # 641px - 900px
      largeLap: "all and (min-width: 56.3125em) and (max-width: 74.9375em)", # 901px - 1199px
      desktopSmall: "all and (min-width: 75em) and (max-width: 85.3125em)", # 1200px - 1365px
      desktopLarge: "all and (min-width: 85.375em)" # 1366px +
    }

    #Palm
    enquire.register mediaQueries.palm, => setTimeout (=>@rebuild 2), 0

    #Small lap
    enquire.register mediaQueries.smallLap, => setTimeout (=>@rebuild 3), 0

    #Large lap
    enquire.register mediaQueries.largeLap, => setTimeout (=>@rebuild 4), 0

    #Desktop small
    enquire.register mediaQueries.desktopSmall, => setTimeout (=>@rebuild 5), 0

    #Desktop large
    enquire.register mediaQueries.desktopLarge, => setTimeout (=>@rebuild 6), 0

  in_groups: (items, number) ->
    number = number - 1
    groups = []

    i = 0
    for item in items
      (groups[i] ||= []).push item

      if i >= number
        i = 0
      else
        i++

    groups

  rebuild: (numberOfCols, force = false) ->

    # Do not re-build if already in that state
    if @currentNumberOfCols != numberOfCols || force

      # Get a template for this number of cols
      $template = $(@templates(numberOfCols))

      # Put the items/tiles into the cols
      for item, index in @in_groups(@items, numberOfCols)
        $template.children(":eq(#{index})").append item

      # Remove broken images, this should be a fall back
      $template.find('img').on 'error', -> $(@).remove()

      # Replace current pinboard with the new one
      $(@pinBoardSelector).replaceWith($template)

      # Remeber the number of the cols so we don't do the same
      # thing twice
      @currentNumberOfCols = numberOfCols

  templates: (numberOfCols) ->
    cols = ""
    for col in [1..numberOfCols]
      cols += """<div class="grid__item one-#{@colTypes[numberOfCols]}"></div>"""
    """
    <div id="pin-board" class="pin-board grid grid--gutter-half grid--flush is-loaded">
      #{cols}
    </div>
    """

@pinBoard = new PinBoard "#pin-board"
@pinBoard.build()