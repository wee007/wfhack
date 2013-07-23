window.map = micello: MapBase: class MapBase

  _waitFor:
    westfield: -> !!window.westfield
    jquery: -> !!window.jQuery

  constructor: (@options) ->
    @index = new map.micello.GeomIndex()
    awaitAll(@_waitFor, @init)

  init: =>
    @community = westfield.centre.micello_community
    if @community == undefined
      throw 'Missing micello_community for centre'
    @index.addStores(westfield.stores)
    
  zoomTo: (storeId) ->
  highlight: (storeId) ->

awaitAll = (waitFor, ready) ->
  allReady = (name) ->
    ((name) ->
      ->
        waitFor[name].ready = true
        for name, test of waitFor
          return unless test.ready
        ready()
    )(name)
  for name, test of waitFor
    wait(allReady(name), test)

wait = (callback, ready) ->
  do ->
    return callback() if ready()
    setTimeout(arguments.callee, 0)
