#= require init/geolocation

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
    tempParent.append list.find(".js-sort-centres-geolocation-#{centre.code}").clone()
    @

  # Get the sorted centre li's and put them in the real DOM
  list.html tempParent.html()

showClosestCentres = (userPosition) ->
  calculateClosestCentresAndState userPosition
  state = selectClosestState()
  sortCentreListByLocation(state)

# Only execute if geolocation is supported
if navigator.geolocation

  # If the user's location is known on page load
  if !!localStorage.userPosition
    # Sort the centres immediately based on that cached location
    showClosestCentres JSON.parse localStorage.userPosition

  # Record how long it takes to get user position
  searchStartTime = new Date().getTime()

  # Get user's position
  navigator.geolocation.getCurrentPosition (userPosition) ->

    # If the users actual position is different to the cache position
    if localStorage.userPosition and userPosition is not localStorage.userPosition

      # Cache the position for future visits
      localStorage.userPosition = JSON.stringify userPosition

      # Show closest centres based on actual location
      showClosestCentres userPosition

  , ->
    @