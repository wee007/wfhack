class window.Map

  key: '458dc5a4-547f-4fb7-a760-575d8176f70b'
  themeFamily: 'Standard'
  customTheme:
    s:
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
    @index = new GeomIndex()
    micello.maps.init(@key, @init)

  init: =>
    wait(@initMap, -> !!window.westfield)
    wait(@attachListeners, -> !!window.jQuery)

  initMap: =>
    @index.addStores(westfield.stores)
    @community = westfield.centre.micello_community
    if @community == undefined
      throw 'Missing micello_community for centre'
    else
      $('#map').text('')
    @getAddresses()
    @control = new micello.maps.MapControl('map')
    @data = @control.getMapData()
    canvas = @control.getMapCanvas()
    @applyCustomTheme(@control.getMapGUI(), canvas)
    @popup = canvas.createPopup()
    @control.onMapClick = @onClick
    @data.mapChanged = @onMapChanged
    @data.loadCommunity(@community)

  attachListeners: =>
    self = @
    $('body', document).on('click', '[data-store-id]', -> self.highlight($(@).data('storeId')))
    $(window).on('resize', @handleResize)

  handleResize: =>
    if @options.select
      resize = =>
        @timeout = null
        @zoomTo(@options.select)
      clearTimeout(@timeout) if @timeout
      @timeout = setTimeout(resize, 100)

  applyCustomTheme: (gui, canvas) ->
    gui.ZOOM_POSITION = 'right top'
    gui.ZOOM_DISPLAY = 'v'
    gui.LEVELS_POSITION = 'right top'
    canvas.setThemeFamily(@themeFamily)
    canvas.setOverrideTheme(@customTheme)

  getAddresses: ->
    $.ajax(
      url: "http://maps.micello.com/v3_java/meta/geo_address/cid/#{@community}?api_key=#{@key}"
      dataType: 'json'
    ).success(@parseAddresses)

  parseAddresses: (data) =>
    return unless data.cid == @community
    @index.addAddresses(data.g)

  zoomTo: (storeId) ->
    index = @highlight(storeId)
    @control.centerOnGeom(index.geom, 100)

  highlight: (storeId) ->
    @data.removeInlay("slct", true)
    index = @index.findById(storeId)
    level = @data.getGeometryLevel(index.gid)
    @data.setLevel(level) if level.id != @data.getCurrentLevel().cid
    @data.addInlay(id: index.gid, t: 'Selected', anm: 'slct')
    @control.showInfoWindow(index.geom, @popupHtml(index.store))
    index

  popupHtml: (store) ->
    popup = @popupContent ||= $('.map-popup__content').html()
    popup = popup.replace(new RegExp("\#{store.#{name}}", 'g'), value) for name, value of store
    popup

  onMapChanged: (event) =>
    return unless event.comLoad
    @geom = {}
    for level in @data.community.d[0].l
      @index.addGeoms(level.g)
    if @options.select
      setTimeout((=> @zoomTo(@options.select)), 0)

  onClick: (mx, my, event) =>
    return if !event || !event.id
    index = @index.findByGid(event.id)
    return if !index || !index.gid || !index.id
    @highlight(index.id)

class GeomIndex

  constructor: ->
    @gid = {}
    @address = {}
    @store = {}

  findById: (id) ->
    @store[id]

  findByGid: (gid) ->
    @gid[gid]

  findByNumber: (number) ->
    @address[number]

  index: (index) ->
    @gid[index.gid] = index if index.gid
    @address[index.number] = index if index.number
    @store[index.id] = index if index.id

  addStore: (store) ->
    index = @findById(store.id) || @findByNumber(store.shop_number) || {}
    index.id = store.id
    index.number = store.shop_number
    index.store = store
    @index(index)

  addGeom: (geom) ->
    index = @findByGid(geom.id) || {}
    index.gid = geom.id
    index.geom = geom
    @index(index)

  addAddress: (address) ->
    address.number = address.ia.replace(/^Unit\|/, '')
    index = null
    store = @findByNumber(address.number)
    geom = @findByGid(address.gid)
    if store && geom && store != geom
      store.gid = geom.gid
      store.geom = geom.geom
      index = store
    else
      index = store || geom || {}
    index.number = address.number
    index.gid = address.gid
    index.address = address
    @index(index)

  addStores: (stores) ->
    @addStore(store) for store in stores

  addGeoms: (geoms) ->
    @addGeom(geom) for geom in geoms

  addAddresses: (addresses) ->
    @addAddress(address) for address in addresses


wait = (callback, ready) ->
  do ->
    return callback() if ready()
    setTimeout(arguments.callee, 0)
