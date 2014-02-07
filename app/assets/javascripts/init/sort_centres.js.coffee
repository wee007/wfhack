#= require init/geolocation
insertOverlayAndPreloader = ->
  html = '<div class="overlay overlay--absolute overlay--light">
    <span class="preloader preloader--top preloader--light">
      <span class="preloader__spinner"></span>
      <em class="hide-visually">Loading, please wait&#8230;</em>
    </span>
  </div>'
  $('.js-sort-centres-geolocation-container').prepend(html)

removeOverlayAndPreloader = ->
  $('.overlay','.js-sort-centres-geolocation-container').remove()

calculateClosestCentresAndState = (userPosition) ->
  # Use haversine algorithm in geolocation module to calculate distance bewteen users and centres.
  $.each westfield.geo, (i, centre) ->
    centre.latitude = parseFloat centre.latitude, 10
    centre.longitude = parseFloat centre.longitude, 10
    centre.distance = Geolocation.distanceFrom userPosition.coords, centre
    @

  westfield.geo.sort (a, b) ->
    a.distance - b.distance

selectClosestState = ->
  # Select current state tab
  closestCentreState = westfield.geo[0].state.toLowerCase()

  # Have to use double quotes here so coffeescript's string interpolation works
  $(".js-sort-centres-geolocation-#{closestCentreState}").trigger 'click'

  return closestCentreState


sortCentreListByLocation = (userState) ->
  # Order centres list by distance from user
  # by cloning html for each centre li closest to furthest
  list = $("#tab-#{userState}")

  # Create a dummy DOM node to store sorted centre li's
  # Adding elements to a node detached from the DOM prevents excessive repaints.
  tempParent = $('<div/>')

  $.each westfield.geo, (i, centre) ->
    tempParent.append list.find(".js-centrecode-#{centre.code}").clone()
    @

  # Get the sorted centre li's and put them in the real DOM
  list.html tempParent.html()

# Only execute if geolocation is supported
if navigator.geolocation
  insertOverlayAndPreloader()

  # Record how long it takes to get user position
  searchStartTime = new Date().getTime()
  navigator.geolocation.getCurrentPosition (userPosition) ->
    searchEndTime = new Date().getTime()

    # If it takes less than a second to get the user position
    # delay the overlay removal and list sorting so it doesn't flash up on the screen momentarily
    extraDelay = 0
    if searchEndTime - searchStartTime < 1000
      extraDelay = 1000 - (searchEndTime - searchStartTime);
    setTimeout (->
      removeOverlayAndPreloader()
      calculateClosestCentresAndState userPosition
      state = selectClosestState()
      sortCentreListByLocation(state)
    ), extraDelay
  , ->
    removeOverlayAndPreloader()
    @



