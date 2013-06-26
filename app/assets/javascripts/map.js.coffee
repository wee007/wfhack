class Map

  key: '458dc5a4-547f-4fb7-a760-575d8176f70b'
  themeFamily: 'Standard'

  constructor: ->
    @index = new GeomIndex()
    micello.maps.init(@key, @init)

  init: =>
    @index.addStores(westfield.stores)
    @community = westfield.centre.micello_community
    if @community == undefined
      $('#map').text('No map, sorry.')
      return
    else
      $('#map').text('')
    @getAddresses()
    @control = new micello.maps.MapControl('map')
    @data = @control.getMapData()
    canvas = @control.getMapCanvas()
    canvas.setThemeFamily(@themeFamily)
    @popup = canvas.createPopup()
    @control.onMapClick = @onClick
    @data.mapChanged = @onMapChanged
    @data.loadCommunity(@community)

  getAddresses: ->
    $.ajax(
      url: "http://maps.micello.com/v3_java/meta/geo_address/cid/#{@community}?api_key=#{@key}"
      dataType: 'json'
    ).success(@parseAddresses)

  parseAddresses: (data) =>
    return unless data.cid == @community
    @index.addAddresses(data.g)

  highlight: (storeId) ->
    @data.removeInlay("slct", true)
    index = @index.findById(storeId)
    level = @data.getGeometryLevel(index.gid)
    @data.setLevel(level) if level.id != @data.getCurrentLevel().cid
    @data.addInlay(id: index.gid, t: 'Selected', anm: 'slct')
    @control.showInfoWindow(index.geom, @popupHtml(index.store))

  popupHtml: (store) ->
    """
    <h1>#{store.name}</h1>
    Enquiries: #{store.phone_number}<br/>
    <a href="#{store.url}">#{store.url}</a>
    """

  onMapChanged: (event) =>
    return unless event.comLoad
    @geom = {}
    for level in @data.community.d[0].l
      @index.addGeoms(level.g)

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
    index = null
    store = @findByNumber(address.ia)
    geom = @findByGid(address.gid)
    if store && geom && store != geom
      store.gid = geom.gid
      store.geom = geom.geom
      index = store
    else
      index = store || geom || {}
    index.number = address.ia
    index.gid = address.gid
    index.address = address
    @index(index)


  addStores: (stores) ->
    @addStore(store) for store in stores

  addGeoms: (geoms) ->
    @addGeom(geom) for geom in geoms

  addAddresses: (addresses) ->
    @addAddress(address) for address in addresses


window.map = new Map

waitForJQuery = (callback) ->
  do ->
    return callback() if window.jQuery
    setTimeout(arguments.callee, 0)

waitForJQuery ->
  $('body', document).on(
    'click',
    '[data-store-id]',
    -> map.highlight($(@).data('storeId'))
  )
