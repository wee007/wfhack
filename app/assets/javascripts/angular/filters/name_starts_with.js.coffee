((app) ->
  app.filter 'nameStartsWith', ->
    (items, search) ->
      return items if !search

      pattern = new RegExp "^" + search, "i"

      items.filter (element, index, array) ->
        pattern.test element.name

) angular.module("Westfield")