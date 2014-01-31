#= require init/geolocation
if navigator.geolocation
  navigator.geolocation.getCurrentPosition (userPosition) ->

    $.each westfield.geo, (i, centre) ->
      centre.latitude = parseFloat centre.latitude, 10
      centre.longitude = parseFloat centre.longitude, 10
      centre.distance = Geolocation.distanceFrom userPosition.coords, centre
      @

    westfield.geo.sort (a, b) ->
      a.distance - b.distance

    #select current state tab

    #order centres list







