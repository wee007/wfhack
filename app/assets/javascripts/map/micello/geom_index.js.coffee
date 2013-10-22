class map.micello.GeomIndex

  constructor: ->
    @gid = {}
    @store = {}
    @type = {}
    @icons = []

  findById: (id) ->
    @store[id]

  findByGid: (gid) ->
    @gid[gid]

  allByType: (type) ->
    @type[type]

  allIcons: ->
    @icons

  index: (index) ->
    @gid[index.gid] = index if index.gid
    @store[index.id] = index if index.id
    (@type[index.type] ||= []).push(index) if index.type
    @icons.push index if index.icon

  addStore: (store) ->
    index = @findById(store.id) || @findByGid(store.micello_geom_id) || {}
    index.id = store.id
    index.gid = store.micello_geom_id
    index.store = store
    @index(index)

  addGeom: (geom) ->
    index = @findByGid(geom.id) || {}
    index.gid = geom.id
    index.icon = geom.lt == 2
    index.type = geom.t
    index.geom = geom
    @index(index)

  addStores: (stores) ->
    @addStore(store) for store in stores

  addGeoms: (geoms) ->
    @addGeom(geom) for geom in geoms
