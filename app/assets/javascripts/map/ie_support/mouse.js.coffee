class map.ie_support.Mouse

  x: false
  y: false
  down: false

  constructor: (@el, @callback) ->
    @el.on('mousedown', @mouseDown)
    @el.on('mouseup', @mouseUp)
    @el.on('mousemove', @mouseMove)

  set: (event) ->
    @x = event.clientX
    @y = event.clientY

  mouseDown: (event) =>
    @down = true
    @set(event)
    false

  mouseUp: (event) =>
    @down = false
    @set(event)
    false

  mouseMove: (event) =>
    dx = event.clientX - @x
    dy = event.clientY - @y
    @callback(x: dx, y: dy) if @down
    @set(event)
    false
