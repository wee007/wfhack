@Geolocation =
  rad: (x) ->
    x * Math.PI / 180


  # Distance in kilometers between two points using the Haversine algo.
  haversine: (p1, p2) ->
    R = 6371
    dLat = @rad(p2.latitude - p1.latitude)
    dLong = @rad(p2.longitude - p1.longitude)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(@rad(p1.latitude)) * Math.cos(@rad(p2.latitude)) * Math.sin(dLong / 2) * Math.sin(dLong / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c
    Math.round d


  # Distance between me and the passed position.
  distanceFrom: (current_location, to) ->
    this.haversine current_location, to