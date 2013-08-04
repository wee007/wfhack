map.micello.ie = Map: class Map extends map.micello.MapBase

  zoomAmount: 1

  constructor: (@options) ->
    super
    @el = $('#map-micello-api')
    @zoomUI = @el.find('.map-micello-oldie__controls__zoom')
    @levelUI = @el.find('.map-micello-oldie__controls__levels .btn')
    @levels = @el.find('.map-micello-oldie__map-img')
    self = @
    @levels.each ->
      el = $(@)
      el.data(width: self.el.width(), height: self.el.height())
      el.width(el.data('width'))
    @zoomUI.on('click', '.map-micello-oldie__controls__zoom__in', -> self.zoom(0.25))
    @zoomUI.on('click', '.map-micello-oldie__controls__zoom__out', -> self.zoom(-0.25))
    @levelUI.on('click', -> self.selectLevel($(@).data('level')))
    $('body', document).on('click', '[data-store-id]', -> self.highlight($(@).data('storeId')))
    unless @el.parent().hasClass('map-micello--static')
      @mouse = new map.micello.ie.Mouse(@levels, @drag)
    @selectLevel(1)
    @highlight(@options.select) if @options.select

  drag: (delta) =>
    top = parseInt(@levels.css('top'), 10)
    left = parseInt(@levels.css('left'), 10)
    @levels.css(top: top + delta.y, left: left + delta.x)

  zoom: (amount) ->
    zoomAmount = Math.max(Math.min(@zoomAmount + amount, 3), 0.5)
    if zoomAmount != @zoomAmount
      @drag(x: amount * @levels.data('width') / -2, y: amount * @levels.data('height') / -2)
      @zoomAmount = zoomAmount
    @levels.each ->
      el = $(@)
      el.width(el.data('width') * zoomAmount)

  selectLevel: (level) ->
    level = parseInt(level)
    selector = "[data-level=\"#{level}\"]"
    @levelUI.removeClass('is-active')
    @levelUI.filter(selector).addClass('is-active')
    @levels.addClass('hide-fully')
    @levels.filter(selector).removeClass('hide-fully')

  highlight: (storeId) ->
    @selectLevel(@index.findById(storeId).store.level || 1)