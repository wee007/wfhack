# The default search option for product search is 'most relevant', however
# it is not returned from the web service.
((app) ->
  app.factory 'SortOptions', ->
    format: (options) ->
      options.unshift({
        code: '',
        description: 'Sort by…',
        active: true,
        display: true
      })

      options

) angular.module("Westfield")