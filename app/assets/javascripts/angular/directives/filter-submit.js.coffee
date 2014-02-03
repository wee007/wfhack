((app) ->
  app.directive 'wfFilterSubmit', [->
    restrict: 'A'
    link: (scope, element) ->
      element.bind 'keydown', (event) ->
        element.find('button:submit').trigger 'click'  if event.keyCode is 13

  ]
) angular.module('Westfield')