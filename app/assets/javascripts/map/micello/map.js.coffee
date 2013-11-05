class map.micello.Map extends map.micello.MapBase

  key: '357b70ed-2c4b-418b-ad09-cf83f9bfc7b4'

  # Error events from images don't bubble so we need to explicitly call onerror
  @removeLogo: (img) ->
    $el = $(img)
    $el.parents('.js-toggle-store-logo').addClass('is-no-store-logo')
    $el.remove()

  constructor: (@options) ->
    super
    @offset = x: 0.5, y: 0.5
    @targetStore = null
    micello.maps.init(@key, @init)

  toggleKeyEvents: (enabled) ->
    @keyEventHandler ||= micello.maps.MapGUI.prototype.onKeyDown
    if enabled
      micello.maps.MapGUI.prototype.onKeyDown = @keyEventHandler
    else
      micello.maps.MapGUI.prototype.onKeyDown = $.noop
    @

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
    super

  init: =>
    @initMap()
    @attachEventListeners()

  initMap: =>
    $('#map-micello-api').text('')
    @control = new micello.maps.MapControl('map-micello-api')
    @data = @control.getMapData()
    canvas = @control.getMapCanvas()
    @applyCustomTheme(@control.getMapGUI(), canvas)
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
    canvas.setThemeFamily(map.micello.customTheme.themeFamily)
    canvas.setOverrideTheme(map.micello.customTheme.theme)
    canvas.MAP_FONT_MIN = "14px"
    canvas.MAP_FONT_MAX = "14px"

  setTarget: ->
    @data.removeInlay("slct", true)
    @control.hideInfoWindow()
    super

  showLevel: ->
    if @hasTarget()
      level = @data.getGeometryLevel(@target.gid)
      @data.setLevel(level) if level.id != @data.getCurrentLevel().cid
    @

  lock: ->
    @locked = true

  zoom: ->
    if @hasTarget()
      @control.centerOnGeom(@target.geom, 100)
    @

  detail: ->
    if @hasTarget()
      level = @data.getCurrentLevel()
      geoms = @data.groupMap[@target.geom?.gid] || [@target.geom]
      for geom in geoms
        if @data.getGeometryLevel(geom.id).id == level.id
          @control.showInfoWindow(geom, @popupHtml(@target.store))
      if @locked # we only bring the popup into the centre if it's the main content
        @zoom()
        @view.translate(0, $('#infoDiv').height() / 2)
    @

  highlight: ->
    if @hasTarget()
      @data.addInlay(id: @target.gid, t: 'Selected', anm: 'slct')
    @

  centre: ->
    if @hasTarget()
      zoom = @view.getZoom()
      @control.centerOnGeom(@target.geom)
      @view.setZoom(zoom)
    @

  @logoOptions:
    width: 168
    height: 62
    crop: 'pad'
    background: 'rgb:FFFFFF'

  popupHtml: (store) =>
    return 'Store not found' unless store.id
    @popupContent ||= _.template($('script.map-micello__overlay-wrap[type="text/html-template"]').html())

    locationMatch = !!location.toString().match(///#{store.storefront_path}///)
    classname = "#{unless store.logo then 'is-no-store-logo' else ''} #{if locationMatch then 'is-active-store' else ''}"
    storefront_path = "#{unless locationMatch then store.storefront_path else ''}"

    data = _.extend({}, store,
      classname: classname
      storefront_path: storefront_path
    )

    @popupContent(data)

  applyCustomIcons: ->
    for geom in  _.pluck((@index.allByType('Entrance') || []).concat(@index.allIcons()), 'geom')
      geom.lr ||= 'Entrance' if geom.t == 'Entrance'
      img = map.micello.customTheme.icons?[geom.lr]
      if img
        @data.addMarkerOverlay(
          id: geom.id
          anm: 'entrance'
          mr:
            src: img
            ox: map.micello.customTheme.icons?.offset.ox
            oy: map.micello.customTheme.icons?.offset.oy
          mt: micello.maps.markertype.IMAGE
        )
      @data.addInlay(id: geom.id, lt: 3, lr: '')

  applyWestfieldStoreNames: ->
    for item in (@index.allByType('Unit') || []).concat(@index.allByType('Building') || [])
      item.geom.nm = item.geom.lr = 'New Store Opening Soon' unless !!item.store
    for store in _(@index.store).toArray()
      store.geom.nm = store.geom.lr = store.store.name if store.geom

  onMapChanged: (event) =>
    @detail() # show the detail popup on the right level if it changed
    return if !event.comLoad || @geomsLoaded
    @geomsLoaded = true
    for level in @data.community.d[0].l
      @index.addGeoms(level.g)
    @applyCustomIcons()
    @applyWestfieldStoreNames()
    @ready()

  onClick: (mx, my, event) =>
    @setTarget()
    return if !event || !event.id
    geoms = _(@data.getGeometryGroupList(event.id) || [event]).pluck('id')
    store = _(westfield.stores).chain()
      .filter((store) -> _(geoms).contains(parseInt(store.micello_geom_id, 10)))
      .first().value()
    return if !store
    @setTarget(store.id).highlight().detail()

  reset: ->
    @control.getMapView().resetView()
    setTimeout =>
      @control.getMapGUI().onResize()
    @recordSize()
    @

  viewportCentre: (offset = @offset, size = @getSize()) ->
    x: size.width * offset.x
    y: size.height * offset.y

  centreOffset: (@offset = @offset) ->
    @view.offsetXFraction = offset.x
    @view.offsetYFraction = offset.y
    @view.defaultMapX = @map_centre.x if @map_centre.x
    @view.defaultMapY = @map_centre.y if @map_centre.y
    @view.home()
    @view.setZoom(offset.zoom || 1)
    @

  getSize: ->
    width: @view.getViewportWidth()
    height: @view.getViewportHeight()

  recordSize: (size) ->
    @size = size || @getSize()

  moveMapForResize: =>
    @timeout = null
    if @locked
      @zoom()
      @detail()
      return
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
