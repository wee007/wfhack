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
    closestCentreState = westfield.geo[0].state.toLowerCase()

    # Have to use double quotes here so coffeescript's string interpolation works
    $(".js-#{closestCentreState}").trigger 'click'

    # Order centres list by distance from user
    # by cloning html for each centre li closest to furthers
    list = $("#tab-#{closestCentreState}")

    # Create a dummy DOM node to store sorted centre li's
    # Adding elements to a node detached from the DOM prevents excessive repaints.
    tempParent = $('<div/>')

    $.each westfield.geo, (i, centre) ->
      tempParent.append list.find(".js-centrecode-#{centre.code}").clone()
      @

    # Get the sorted centre li's and put them in the real DOM
    list.html tempParent.html()