class map.ResponsiveMap extends map.Micello

  constructor: (@options = {}) ->
    super
    @visible = false
    @state = 'palm'
    $(@initEnquire)

  initEnquire: =>
    enquire.register(@options.breakpoint, {
      match: @nonPalmView,
      unmatch: @palmView,
      setup: @palmView
    }, true)

  toggle: ->
    @visible = !@visible
    @palmView() if @state == 'palm'
    @visible

  nonPalmView: =>
    @state = 'nonpalm'
    @show(@options.nonPalm)

  palmView: =>
    @state = 'palm'
    @show(@options.palm) if @visible

  show: (options) ->
    map = @load()
    setTimeout((-> map.centreOffset(options.offset)), 0)
