class map.micello.Map extends map.micello.MapBase

  key: '357b70ed-2c4b-418b-ad09-cf83f9bfc7b4'
  themeFamily: 'Standard'
  customTheme:
    s:
      'Selected':
        m: '#d7ccbd'
        o: '#695648'
        t: '#333333'
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

  # Error events from images don't buddle so we need to explicitly call onerror
  @removeImage: (img) ->
    $el = $(img)
    $el.parents('.js-toggle-logo-image').addClass('is-no-store-logo')
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

  ready: ->
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
    quality: 25
    crop: 'pad'
    background: 'rgb:FFFFFF'

  popupHtml: (store) ->
    return 'Store not found' unless store.id
    if store?._links?.logo?.href?
      store.logo = $.cloudinary.fetch_image(store._links.logo.href, @logoOptions).attr('src')
    popup = @popupContent ||= $('.map-micello__overlay-wrap').html()
    popup = popup.replace(new RegExp("\#{store.#{name}}", 'g'), value) for name, value of store
    popup = $(popup)
    removeLogo.call(popup.find('img')) unless store.logo
    popup[0].outerHTML

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

  maxTranslate: (translate) ->
    size = @getSize()
    halfWidth = size.width / 2 - @view.mapXInViewport
    halfHeight = size.height / 2 - @view.mapYInViewport
    translate.x = Math.min(Math.max(translate.x, -halfWidth), halfWidth)
    translate.y = Math.min(Math.max(translate.y, -halfHeight), halfHeight)
    translate

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
    translate = @maxTranslate @viewportCentreOffsetDelta()
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
