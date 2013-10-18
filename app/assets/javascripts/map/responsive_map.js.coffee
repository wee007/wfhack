class map.ResponsiveMap extends map.Micello

  constructor: (@options = {}) ->
    super
    @visible = false
    @state = 'palm'
    $(@initEnquire)
    @toggleKeyEvents(false)

  initEnquire: =>
    enquire.register(@options.breakpoint, {
      match: @nonPalmView,
      unmatch: @palmView,
      setup: @palmView
    }, true)

  show: ->
    @toggle on

  hide: ->
    @toggle off

  toggle: (@visible = !@visible) ->
    @palmView() if @state == 'palm'
    @visible

  nonPalmView: =>
    @state = 'nonpalm'
    @load(@options.nonPalm)

  palmView: =>
    @state = 'palm'
    @load(@options.palm) if @visible

  load: (options) ->
    map = super
    setTimeout((-> map.centreOffset(options.offset)), 0)
