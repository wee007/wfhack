class @PinBoard

  constructor: (items) ->
    # Clone the items are they get removed, and added between breakpoints
    @items = $('#pin-board .tile').clone()
    # The palm is default, since we are mobile 1st.
    @currentNumberOfCols = 2

  build: ->

    #Palm
    enquire.register "screen and (max-width: 640px)", =>
      @rebuild 2

    #Lap
    enquire.register "screen and (min-width: 641px) and (max-width: 1199px)", =>
      @rebuild 3

    #Desktop
    enquire.register "screen and (min-width: 1200px)", =>
      @rebuild 5

  in_groups: (items, number) ->
    number = number - 1
    groups = []

    for index in [0..number]
      groups.push []

    i = 0
    for item in items
      groups[i].push item
      if i >= number
        i = 0
      else
        i++

    groups

  rebuild: (numberOfCols, force = false) ->

    # Do not re-build if already in that state
    if @currentNumberOfCols != numberOfCols || force

      # Get a template for this number of cols
      $template = $(@templates[numberOfCols])

      # Put the items/tiles into the cols
      for item, index in @in_groups(@items, numberOfCols)
        $template.children(":eq(#{index})").append item

      # Remove broken images, this should be a fall back
      $template.find('img').on 'error', -> $(@).remove()

      # Replace current pinboard with the new one
      $("#pin-board").replaceWith($template)

      # Remeber the number of the cols so we don't do the same
      # thing twice
      @currentNumberOfCols = numberOfCols

  templates:
    2: """
    <div id="pin-board" class="grid grid--gutter-half pin-board is-active">
      <div class="grid__item one-half"></div>
      <div class="grid__item one-half"></div>
    </div>
    """

    3: """
    <div id="pin-board" class="grid grid--gutter-half pin-board is-active">
      <div class="grid__item one-third"></div>
      <div class="grid__item one-third"></div>
      <div class="grid__item one-third"></div>
    </div>
    """

    5: """
    <div id="pin-board" class="grid grid--gutter-half pin-board is-active">
      <div class="grid__item one-fifth"></div>
      <div class="grid__item one-fifth"></div>
      <div class="grid__item one-fifth"></div>
      <div class="grid__item one-fifth"></div>
      <div class="grid__item one-fifth"></div>
    </div>
    """

@pinBoard = new PinBoard $('.tile')
@pinBoard.build()
