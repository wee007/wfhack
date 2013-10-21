class map.micello.GeomIndex

  constructor: ->
    @gid = {}
    @address = {}
    @store = {}
    @type = {}
    @icons = []

  findById: (id) ->
    @store[id]

  findByGid: (gid) ->
    @gid[gid]

  findByNumber: (number) ->
    @address[number]

  allByType: (type) ->
    @type[type]

  allIcons: ->
    @icons

  index: (index) ->
    @gid[index.gid] = index if index.gid
    @address[index.number] = index if index.number
    @store[index.id] = index if index.id
    (@type[index.type] ||= []).push(index) if index.type
    @icons.push index if index.icon

  addStore: (store) ->
    index = @findById(store.id) || @findByNumber(store.shop_number) || {}
    index.id = store.id
    index.number = store.shop_number
    index.store = store
    @index(index)

  addGeom: (geom) ->
    index = @findByGid(geom.id) || {}
    index.gid = geom.id
    index.icon = geom.lt == 2
    index.type = geom.t
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
