((app) ->
  app.filter 'formatPriceRange', ->
    (priceRangeString) ->
      [low, high] = priceRangeString.split('-')
      return "$#{low}–$#{high}"

) angular.module("Westfield")