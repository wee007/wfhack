class map.micello.Map

  key: '357b70ed-2c4b-418b-ad09-cf83f9bfc7b4'

  # Error events from images don't bubble so we need to explicitly call onerror
  @removeLogo: (img) ->
    $el = $(img)
    $el.parents('.js-toggle-store-logo').addClass('is-no-store-logo')
    $el.remove()

  constructor: (@options) ->
    @deferreds =
      stores: $.Deferred()
      micello: $.Deferred()
    @community = westfield.centre.micello_community
    @map_centre = westfield.centre.micello_map_centre || {x: 0, y: 0}
    if @community == undefined
      throw 'Missing micello_community for centre'
    @offset = x: 0.5, y: 0.5
    @fetchStores()
    $.when(@deferreds.stores, @deferreds.micello).then(@ready)

  westfieldCentreId: ->
    westfield.centre.code

  fetchStores: ->
    $.getJSON("/api/store/master/stores?centre=#{@westfieldCentreId()}&per_page=9999", @processStores)

  processStores: (stores) =>
    micello.maps.init(@key, @init)
    _(stores).each (store) =>
      if store._links.logo?.href?
        store.logo = store._links.logo.href
      closingTime = store.today_closing_time || westfield.centre.today_closing_time
      store.closing_time_24 = closingTime
      hour24 = parseInt(closingTime, 10)
      hour12 = hour24 % 12
      hour12 = 12 if hour12 == 0
      minute = closingTime.replace(/\d+:/, '')
      ampm = if hour24 < 12 || hour24 == 24 then 'am' else 'pm'
      store.closing_time_12 = "#{hour12}:#{minute}#{ampm}"
      store.storefront_path = "/#{@westfieldCentreId()}/stores/#{store.retailer_code}/#{store.id}"
    @stores =
      list: stores
      idMap: _(stores).chain().map((store) -> [store.id, store]).object().value()
      micelloMap: _(stores).chain().map((store) -> [store.micello_geom_id, store]).object().value()
    @deferreds.stores.resolve()

  processGeoms: (geoms) ->
    @geoms =
      list: geoms
      idMap: _(geoms).chain().map((geom) -> [geom.id, geom]).object().value()
      gidMap: _(geoms).chain().map((geom) -> geom.gid ||= geom.id; geom).groupBy('gid').value()
      typeMap: _(geoms).groupBy('t')
      stores: _(geoms).filter((geom) -> geom.t == 'Unit' || geom.t == 'Building')
      icons: _(geoms).filter((geom) -> geom.lt == 2 || geom.t == 'Entrance')
      types: (types) ->
        geoms = []
        geoms = geoms.concat(@typeMap[type]) for type in types
        geoms

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

  ready: =>
    @patchMicelloAPI()
    @applyCustomIcons()
    @applyWestfieldStoreNames()
    @options.deferred.resolveWith(@)

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

  setTarget: (@storeId) ->
    @data.removeInlay("slct", true)
    @control.hideInfoWindow()
    @

  targetStore: ->
    @stores.idMap[@storeId] if @hasTarget()

  targetGeom: ->
    @geoms.idMap[@targetStore().micello_geom_id] if @hasTarget()

  targetGeomGroup: ->
    @geomGroupForStore(@targetStore()) if @hasTarget()

  store: (id) ->
    @stores.idMap[id]

  storeForGeomGroup: (geoms) ->
    _(geoms).chain().map((geom) => @stores.micelloMap[geom.id]).compact().first().value()

  geomGroupForGeom: (geom) ->
    @geoms.gidMap[geom.gid]

  geomGroupForStore: (store) ->
    storeGeom = @geoms.idMap[store.micello_geom_id]
    geoms = @geoms.gidMap[storeGeom.gid] if storeGeom
    geoms || []

  hasTarget: ->
    !!@storeId

  pinGeom: (geom) ->
    @data.addMarkerOverlay
      id: geom.id
      mt: micello.maps.markertype.IMAGE
      mr: westfield.pin
      anm: 'pins'

  pinStores: (store_ids) ->
    _(store_ids).chain()
      .map((store) => @geomGroupForStore(@store(id)))
      .flatten().compact()
      .each((geom) => @pinGeom(geom) if geom) # add a pin to each geom
    @

  clearPins: ->
    @data.removeMarkerOverlay("pins", true)
    @

  showLevel: ->
    if @hasTarget()
      level = @data.getGeometryLevel(@targetGeom().id)
      @data.setLevel(level) if level && level.id != @data.getCurrentLevel().cid
    @

  lock: ->
    @locked = true

  zoom: ->
    if @hasTarget()
      @control.centerOnGeom(@targetGeom(), 100)
    @

  detail: ->
    if @hasTarget() && @targetGeom() && @hasPopup()
      level = @data.getCurrentLevel()
      for geom in @targetGeomGroup()
        if @data.getGeometryLevel(geom.id).id == level.id
          @control.showInfoWindow(geom, @popupHtml(@targetStore()))
      if @locked # we only bring the popup into the centre if it's the main content
        @zoom()
        @view.translate(0, $('#infoDiv').height() / 2)
    @

  highlight: ->
    if @hasTarget()
      @data.addInlay(id: @targetGeom().gid, t: 'Selected', anm: 'slct')
    @

  centre: ->
    if @hasTarget()
      zoom = @view.getZoom()
      @control.centerOnGeom(@targetGeom())
      @view.setZoom(zoom)
    @

  @logoOptions:
    width: 168
    height: 62
    crop: 'pad'
    background: 'rgb:FFFFFF'

  hasPopup: ->
    $('script.map-micello__overlay-wrap[type="text/html-template"]').length > 0

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
    for geom in @geoms.icons
      img = map.micello.customTheme.icons?[geom.lr]
      if img
        @data.addMarkerOverlay(
          id: geom.id
          anm: 'icon'
          mr:
            src: img
            ox: map.micello.customTheme.icons?.offset.ox
            oy: map.micello.customTheme.icons?.offset.oy
          mt: micello.maps.markertype.IMAGE
        )
      @data.addInlay(id: geom.id, lt: 3, lr: '')

  setGeomName: (geom, name) ->
    geom.nm = geom.lr = name

  applyWestfieldStoreNames: ->
    for geom in @geoms.types(['Building', 'Unit'])
      geoms = @geomGroupForGeom(geom)
      unless @storeForGeomGroup(geoms)
        @setGeomName(geom, 'New Store Opening Soon') for geom in geoms
    for store in @stores.list
      for geom in @geomGroupForStore(store)
        @setGeomName(geom, store.name)

  onMapChanged: (event) =>
    @detail() # show the detail popup on the right level if it changed
    return if !event.comLoad || @geomsLoaded
    @geomsLoaded = true
    @processGeoms(_(@data.geomMap).pluck('g'))
    @deferreds.micello.resolve()

  onClick: (mx, my, event) =>
    @setTarget()
    return if !event || !event.id
    geom = @geoms.idMap[event.id]
    store = @storeForGeomGroup(@geoms.gidMap[geom.gid])
    @setTarget(store.id).highlight().detail() if store

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
