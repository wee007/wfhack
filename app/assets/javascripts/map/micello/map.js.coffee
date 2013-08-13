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

  constructor: (@options) ->
    super
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

  attachEventListeners: =>
    $(window).on('resize', @handleResize)

  handleResize: =>
    if @targetStore?
      resize = =>
        @timeout = null
        @zoomTo(@targetStore)
      clearTimeout(@timeout) if @timeout
      @timeout = setTimeout(resize, 100)

  applyCustomTheme: (gui, canvas) ->
    gui.ZOOM_POSITION = 'right top'
    gui.ZOOM_DISPLAY = 'v'
    gui.LEVELS_POSITION = 'right top'
    canvas.setThemeFamily(@themeFamily)
    canvas.setOverrideTheme(@customTheme)

  zoomTo: (storeId) ->
    return if storeId == undefined
    index = @highlight(storeId)
    @control.centerOnGeom(index.geom, 100)
    @targetStore = storeId

  highlight: (storeId) ->
    return if storeId == undefined
    @targetStore = storeId
    @data.removeInlay("slct", true)
    index = @index.findById(storeId)
    level = @data.getGeometryLevel(index.gid)
    @data.setLevel(level) if level.id != @data.getCurrentLevel().cid
    @data.addInlay(id: index.gid, t: 'Selected', anm: 'slct')
    @control.showInfoWindow(index.geom, @popupHtml(index.store))
    index

  popupHtml: (store) ->
    store.logo = store._links.logo.href if store?.links?.logo?.href?
    popup = @popupContent ||= $('.map-micello__overlay-wrap').html()
    popup = popup.replace(new RegExp("\#{store.#{name}}", 'g'), value) for name, value of store
    popup

  onMapChanged: (event) =>
    return unless event.comLoad
    @geom = {}
    for level in @data.community.d[0].l
      @index.addGeoms(level.g)
    @ready()

  onClick: (mx, my, event) =>
    return if !event || !event.id
    index = @index.findByGid(event.id)
    return if !index || !index.gid || !index.id
    @highlight(index.id)
