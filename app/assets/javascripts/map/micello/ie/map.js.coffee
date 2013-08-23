map.micello.ie = Map: class Map extends map.micello.MapBase

  zoomAmount: 1

  constructor: (@options) ->
    super
    @html = @getElements()
    @setSizeData(@html.levelImages)
    @attachEvents()
    unless @html.el.parent().hasClass('map-micello--static')
      @mouse = new map.micello.ie.Mouse(@html.levelImages, @drag)
    @selectLevel(1)
    setTimeout @ready

  attachEvents: ->
    self = @
    @html.ui.zoom.on('click', '.map-micello-oldie__controls__zoom__in', => @zoom(0.25))
    @html.ui.zoom.on('click', '.map-micello-oldie__controls__zoom__out', => @zoom(-0.25))
    @html.ui.levels.on('click', -> self.selectLevel($(@).data('level')))

  setSizeData: (els) ->
    size = width: @html.el.width(), height: @html.el.height()
    els.each ->
      el = $(@)
      el.data(size).width(el.data('width'))

  getElements: ->
    html = el: $('#map-micello-api')
    html.levelImages = html.el.find('.map-micello-oldie__map-img')
    html.ui =
      zoom: html.el.find('.map-micello-oldie__controls__zoom')
      levels: html.el.find('.map-micello-oldie__controls__levels .btn')
    html

  drag: (delta) =>
    top = parseInt(@html.levelImages.css('top'), 10)
    left = parseInt(@html.levelImages.css('left'), 10)
    @html.levelImages.css(top: top + delta.y, left: left + delta.x)

  zoom: (amount) ->
    zoomAmount = Math.max(Math.min(@zoomAmount + amount, 3), 0.5)
    if zoomAmount != @zoomAmount
      @drag(x: amount * @html.levelImages.data('width') / -2, y: amount * @html.levelImages.data('height') / -2)
      @zoomAmount = zoomAmount
    @html.levelImages.each ->
      el = $(@)
      el.width(el.data('width') * zoomAmount)

  selectLevel: (level) ->
    level = parseInt(level)
    selector = "[data-level=\"#{level}\"]"
    @html.ui.levels.removeClass('is-active')
    @html.ui.levels.filter(selector).addClass('is-active')
    @html.levelImages.addClass('hide-fully')
    @html.levelImages.filter(selector).removeClass('hide-fully')

  showLevel: ->
    @selectLevel(@target.store.level || 1) if @hasTarget()
    @

map.micello.Map = map.micello.ie.Map unless map.micello.Map
