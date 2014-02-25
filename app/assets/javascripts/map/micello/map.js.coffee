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
      store_hours: $.Deferred()
      store_fetch: $.Deferred()
    @community = westfield.centre.micello_community
    @map_centre = westfield.centre.micello_map_centre || {x: 0, y: 0}
    if @community == undefined
      throw 'Missing micello_community for centre'
    @offset = x: 0.5, y: 0.5
    @fetchStores()
    $.when(@deferreds.store_fetch).then(@fetchTradingHours)
    $.when(@deferreds.store_hours).then(@processStores)
    $.when(@deferreds.stores, @deferreds.micello).then(@ready)

  westfieldCentreId: ->
    westfield.centre.code

  fetchStores: =>
    $.getJSON "/api/store/master/stores?centre=#{@westfieldCentreId()}&per_page=9999", (data) =>
      @stores = data
      @deferreds.store_fetch.resolve()

  fetchTradingHours: =>
    d = new Date()
    curr_date = d.getDate()
    curr_month = d.getMonth() + 1
    curr_year = d.getFullYear()
    today = curr_date + "-" + curr_month + "-" + curr_year
    stores_for_url = (_.map @stores, (store) -> "store_id[]=#{store.id}").join("&")
    $.getJSON "/api/trading-hour/master/store_trading_hours/range.json?centre_id=bondijunction&#{stores_for_url}&from=#{today}&to=#{today}", (data) =>
      @store_trading_hours = _(data).chain().map((store_hours) -> [store_hours.store_id, store_hours]).object().value()
      @deferreds.store_hours.resolve()

  processStores: =>
    micello.maps.init(@key, @init)
    _(@stores).each (store) =>
      if store._links.logo?.href?
        store.logo = store._links.logo.href
      closingTime = @store_trading_hours[store.id].closing_time
      store.closing_time_24 = closingTime
      hour24 = parseInt(closingTime, 10)
      hour12 = hour24 % 12
      hour12 = 12 if hour12 == 0
      minute = closingTime.replace(/\d+:/, '')
      ampm = if hour24 < 12 || hour24 == 24 then 'am' else 'pm'
      store.closing_time_12 = "#{hour12}:#{minute}#{ampm}"
      store.storefront_path = "/#{@westfieldCentreId()}/stores/#{store.retailer_code}/#{store.id}"
    @stores =
      list: @stores
      idMap: _(@stores).chain().map((store) -> [store.id, store]).object().value()
      micelloMap: _(@stores).chain().map((store) -> [store.micello_geom_id, store]).object().value()

    @deferreds.stores.resolve()

  processGeoms: (geoms) ->
    @geoms =
      list: geoms
      idMap: _(geoms).chain().map((geom) -> [geom.id, geom]).object().value()
      gidMap: _(geoms).chain().map((geom) -> geom.gid ||= geom.id; geom).groupBy('gid').value()
      typeMap: _(geoms).groupBy('t')
      stores: _(geoms).filter((geom) -> geom.t == 'Unit' || geom.t == 'Building')
      icons: _(geoms).chain().filter((geom) -> geom.lt == 2 || geom.t == 'Entrance').map((geom) -> geom.lr ||= geom.t; geom).value()
      types: (types) ->
        geoms = []
        (geoms = geoms.concat(@typeMap[type]) if @typeMap[type]) for type in types
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

    # fixes windows chrome canvas redraw bug causing a blank map on page load
    setInterval(@forceRedraw, 1000)

  init: =>
    # Overriding Micello's "mouse shield" fixes stores list no scrolling issue
    micello.maps.MapGUI.prototype.createMouseShield = ->
      @shield = document.createElement("div")
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
    @clearPins('pin')
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

  hasTargetGeom: ->
    !!@targetGeom()

  isPinned: (geom) ->
    @pinned?.ids?[geom.id] != undefined

  rememberPin: (key, id) ->
    @pinned ||= {keys: {}, ids: {}}
    (@pinned.keys[key] ||= []).push(id)
    (@pinned.ids[id] ||= []).push(key)

  fogetPinGroup: (key) ->
    if ids = @pinned?.keys?[key]
      delete @pinned.keys[key]
      (delete @pinned.ids[id]) for id in ids

  pinGeom: (geom, anm = 'pins') ->
    @rememberPin(anm, geom.id)
    pin =
      id: geom.id
      mt: micello.maps.markertype.IMAGE
      mr: map.micello.customTheme.pin
      anm: anm
    @data.addMarkerOverlay(pin, true)
    $(pin.element).on('click', => @onClick(pin.mx, pin.my, pin))

  levelStyle: ->
    @style ||= $('<style></style>').appendTo('body')

  clearLevelCounts: ->
    @levelStyle().html('')
    @

  setLevelCount: (id, count) ->
    @levelStyle().get(0).innerHTML += "#ui-levels-floor-#{id}.ui_levels_floor:before { content: '#{count}'; }"

  pinStore: (withCount = false, andGotoLevel = false) ->
    @clearPins()
    if @hasTargetGeom()
      if(withCount)
        @pinStores([@targetStore().id], andGotoLevel)
      else
        @pinGeom(geom) for geom in @targetGeomGroup()

  pinStores: (store_ids, andGotoLevel = true, anm = 'pins') ->
    # pinStores might be called by the keyword filter before the map has loaded, so check if the stores list is populated
    if @stores?
      @clearLevelCounts()
      @clearPins()
      levels = _(store_ids).chain()
        .map((id) => @geomGroupForStore(@store(id)))
        .flatten().compact()
        .map((geom) => @pinGeom(geom, anm); @data.getGeometryLevel(geom.id))
        .groupBy('id')
        .map((levels, id) => @setLevelCount(id, levels.length); [id, levels])
        .value()
      needsLevelChange = levels.length > 0 && !_(levels).chain().pluck(0).contains(@data.getCurrentLevel().id.toString()).value()
      if andGotoLevel && needsLevelChange
        @data.setLevel _(levels).max((level) -> level[1].length)[1][0]
      @

  clearPins: (anm = 'pins') ->
    @fogetPinGroup(anm)
    @data?.removeMarkerOverlay(anm, true)
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
          $('.infoOut').addClass('is-pinned-store') if @isPinned(geom)
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

  hasPopup: ->
    $('script.map-micello__overlay-wrap[type="text/html-template"]').length > 0

  popupHtml: (store) =>
    return 'Store not found' unless store.id
    @popupContent ||= _.template($('script.map-micello__overlay-wrap[type="text/html-template"]').html())

    locationMatch = !!location.toString().match(///#{store.storefront_path}///)
    classname = []
    classname.push('is-no-store-logo') unless store.logo
    classname.push('is-active-store') if locationMatch
    classname = classname.join(' ')
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

  forceRedraw: ->
    container = $('.js-stores-maps-toggle-wrap, canvas')
    container.css('width', '-=1px')
    container.css('width', '')

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
