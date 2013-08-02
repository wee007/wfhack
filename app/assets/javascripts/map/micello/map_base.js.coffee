window.map.micello = MapBase: class MapBase

  constructor: (@options) ->
    @index = new map.micello.GeomIndex()
    @community = westfield.centre.micello_community
    if @community == undefined
      throw 'Missing micello_community for centre'
    @index.addStores(westfield.stores)

  ready: ->
    @options.deferred.resolveWith(@)
    
  zoomTo: (storeId) ->
  highlight: (storeId) ->
