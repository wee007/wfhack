class map.micello.Map extends map.micello.MapBase

  key: '357b70ed-2c4b-418b-ad09-cf83f9bfc7b4'
  themeFamily: 'Standard'
  customTheme:
    s:
      'Selected':
        m: '#695648'
        o: '#695648'
        t: '#ffffff'
        w: 1
      'Unit':
        m: '#f7f2df'
        o: '#d8bca9'
        t: '#695648'
        w: 1
      'Background':
        m: '#ffffff'
        o: '#dbd9d7'
        w: 10
      'Inaccessible Space':
        m: '#dbd9d7'
      'Open Obstruction':
        m: '#f7f5f2'
      'Level Change':
        m: '#ffebc2'
        o: '#ffb870'
        w: 1
      'Room':
        m: '#ffebc2'
        o: '#ffb870'
        w: 1
      'Building':
        m: '#f7f2df'
        o: '#d8bca9'
        t: '#695648'
        w: 1
      'Water':
        m: '#e1f0ff'
      'Parking Lot':
        m: '#bfbebd'
      'Parking Structure':
        m: '#bfbebd'
      'Grass':
        w: 0
      'Traffic Marker':
        w: 0
      'Parking Spot':
        w: 0
      'Entrance':
        m: '#695648'

  # Error events from images don't buddle so we need to explicitly call onerror
  @removeLogo: (img) ->
    $el = $(img)
    $el.parents('.js-toggle-store-logo').addClass('is-no-store-logo')
    $el.remove()

  constructor: (@options) ->
    super
    @offset = x: 0.5, y: 0.5
    @targetStore = null
    @getAddresses()
    micello.maps.init(@key, @init)

  micelloAddressApiUrl: ->
    "http://maps.micello.com/v3_java/meta/geo_address/cid/#{@community}?api_key=#{@key}"

  getAddresses: ->
    @addressFetch = $.ajax(
      url: @micelloAddressApiUrl()
      dataType: 'json'
    ).success(@parseAddresses)

  parseAddresses: (data) =>
    return unless data.cid == @community
    @index.addAddresses(data.g)

  patchMicelloAPI: ->
    limit = (value, options) ->
      Math.min(Math.max(value, options.min), options.max)

    micello.maps.MapView.prototype.translate = (x,y) ->
      width = @viewport.offsetWidth
      halfHeight = @viewport.offsetHeight / 2
      @mapXInViewport = limit(@mapXInViewport + x, max: width, min: width / 2 - @baseWidth * @scale)
      @mapYInViewport = limit(@mapYInViewport + y, max: halfHeight, min: halfHeight - @baseHeight * @scale)
      @mapElement.style.left = @mapXInViewport + "px"
      @mapElement.style.top = @mapYInViewport + "px"
      @mapCanvas.onPan(-@mapXInViewport, -@mapYInViewport, -@mapXInViewport + @viewport.offsetWidth, -@mapYInViewport + @viewport.offsetHeight)
      if @onViewChange
        @event.pan = 1
        @event.zoom = 0
        @onViewChange(@event)

  ready: ->
    @patchMicelloAPI()
    if @addressFetch.state() == 'resolved'
      super
    else
      @addressFetch.then => super

  init: =>
    @initMap()
    @attachEventListeners()

  initMap: =>
    $('#map-micello-api').text('')
    @control = new micello.maps.MapControl('map-micello-api')
    @data = @control.getMapData()
    canvas = @control.getMapCanvas()
    @applyCustomTheme(@control.getMapGUI(), canvas)
    @popup = canvas.createPopup()
    @control.onMapClick = @onClick
    @data.mapChanged = @onMapChanged
    @data.loadCommunity(@community)
    @view = @control.getMapView()

  attachEventListeners: =>
    @recordSize()
    $(window).on('resize', @handleResize)

  applyCustomTheme: (gui, canvas) ->
    gui.ZOOM_POSITION = 'right top'
    gui.ZOOM_DISPLAY = 'v'
    gui.LEVELS_POSITION = 'right top'
    canvas.setThemeFamily(@themeFamily)
    canvas.setOverrideTheme(@customTheme)

  setTarget: ->
    @data.removeInlay("slct", true)
    @control.hideInfoWindow()
    super

  showLevel: ->
    if @hasTarget()
      level = @data.getGeometryLevel(@target.gid)
      @data.setLevel(level) if level.id != @data.getCurrentLevel().cid
    @

  zoom: ->
    if @hasTarget()
      @control.centerOnGeom(@target.geom, 100)
      @applyOffset()
    @

  detail: ->
    if @hasTarget()
      @control.showInfoWindow(@target.geom, @popupHtml(@target.store))
    @

  highlight: ->
    if @hasTarget()
      @data.addInlay(id: @target.gid, t: 'Selected', anm: 'slct')
    @

  centre: ->
    if @hasTarget()
      zoom = @view.getZoom()
      @control.centerOnGeom(@target.geom)
      offset = @viewportCentre()
      @view.setZoom(zoom)
      @applyOffset()
    @

  logoOptions:
    width: 168
    height: 62
    crop: 'pad'
    background: 'rgb:FFFFFF'

  popupHtml: (store) =>
    return 'Store not found' unless store.id
    popup = @popupContent ||= $('.map-micello__overlay-wrap').html()
    if !!store?._links?.logo?.href
      store.logo = $.cloudinary.fetch_image(store._links.logo.href, @logoOptions).attr('alt', "#{store.name} logo").attr('onerror', 'map.micello.Map.removeLogo(this)')[0].outerHTML
    else
      store.logo = ''
      popup  = popup.replace(/(js-toggle-store-logo)/, '$1 is-no-store-logo')
    if !!location.toString().match(///#{store.storefront_path}///)
      popup = popup.replace(/(js-toggle-store-logo)/, '$1 is-active-store')
    else
      popup = popup.replace(/(button.*js-stores-maps-toggle-btn)/, '$1 hide-visually')
    popup = popup.replace(new RegExp("\#{store.#{name}}", 'g'), value) for name, value of store
    popup

  onMapChanged: (event) =>
    return unless event.comLoad
    @geom = {}
    for level in @data.community.d[0].l
      @index.addGeoms(level.g)
    @ready()

  onClick: (mx, my, event) =>
    @setTarget()
    return if !event || !event.id
    index = @index.findByGid(event.id)
    return if !index || !index.gid || !index.id
    @setTarget(index.id).highlight().detail()

  reset: ->
    @control.getMapView().resetView()
    setTimeout =>
      @control.getMapGUI().onResize()
    @recordSize()
    @

  viewportCentre: (offset = @offset, size = @getSize()) ->
    x: size.width * offset.x
    y: size.height * offset.y

  viewportCentreOffsetDelta: ->
    size = @getSize()
    centre = @viewportCentre({x: 0.5, y: 0.5}, size)
    offset = @viewportCentre(@offset, size)

    x: offset.x - centre.x
    y: offset.y - centre.y

  applyOffset: (@offset = @offset) ->
    translate = @viewportCentreOffsetDelta()
    @view.translate(translate.x, translate.y)

  centreOffset: (offset) ->
    @reset()
    @applyOffset(offset)
    @

  getSize: ->
    width: @view.getViewportWidth()
    height: @view.getViewportHeight()

  recordSize: (size) ->
    @size = size || @getSize()

  moveMapForResize: =>
    @timeout = null
    size = @getSize()
    return if size.width == 0 || size.height == 0
    dX = (size.width - @size.width) / 2
    dY = (size.height - @size.height) / 2
    @view.translate(dX, dY)
    dZoomX = size.width / @size.width
    dZoomY = size.height / @size.height
    dZoom = (dZoomX + dZoomY) / 2
    offset = @viewportCentre(@offset, size)
    @view.setZoom(@view.getZoom() * dZoom, offset.x, offset.y)
    @recordSize(size)

  handleResize: =>
    clearTimeout(@timeout) if @timeout
    @timeout = setTimeout(@moveMapForResize, 100)
