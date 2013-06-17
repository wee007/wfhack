class Map

  key: '458dc5a4-547f-4fb7-a760-575d8176f70b'
  themeFamily: 'Standard'

  constructor: ->
    micello.maps.init(@key, @init)

  init: =>
    @community = westfield.centre.micello_community
    if @community == undefined
      $('#map').text('No map, sorry.')
      return
    else
      $('#map').text('')
    @control = new micello.maps.MapControl('map')
    @data = @control.getMapData()
    @control.getMapCanvas().setThemeFamily(@themeFamily)
    @data.loadCommunity(@community)

window.map = new Map
