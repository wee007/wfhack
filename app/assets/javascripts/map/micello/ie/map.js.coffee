map.micello.ie = Map: class Map extends map.micello.MapBase

  zoomAmount: 1

  init: =>
    super
    @el = $('#map')
    @zoomUI = @el.find('.zoom')
    @levelUI = @el.find('.level-select__level')
    @levels = @el.find('img')
    self = @
    @levels.each ->
      el = $(@)
      el.data(width: self.el.width(), height: self.el.height())
      el.width(el.data('width'))
    @zoomUI.on('click', '.zoom__in', -> self.zoom(0.25))
    @zoomUI.on('click', '.zoom__out', -> self.zoom(-0.25))
    @levelUI.on('click', -> self.selectLevel($(@).data('level')))
    $('body', document).on('click', '[data-store-id]', -> self.highlight($(@).data('storeId')))
    unless @el.hasClass('map--non-interactive')
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
    @levelUI.removeClass('selected')
    @levelUI.filter(selector).addClass('selected')
    @levels.addClass('hidden')
    @levels.filter(selector).removeClass('hidden')

  highlight: (storeId) ->
    @selectLevel(@index.findById(storeId).store.level || 1)
