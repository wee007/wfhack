// pinched from http://stackoverflow.com/a/14519881

(function ( app ) {
  app.directive('ngCheckList', function() {
    return {
      scope: {
        list: '=ngCheckList',
        value: '@'
      },
      link: function(scope, elem, attrs) {
        var handler = function(setup) {
          var checked = elem.prop('checked');
          var index = scope.list.indexOf(scope.value);

          if (checked && index == -1) {
            if (setup) elem.prop('checked', false);
            else scope.list.push(scope.value);
          } else if (!checked && index != -1) {
            if (setup) elem.prop('checked', true);
            else scope.list.splice(index, 1);
          }
        };

        var setupHandler = handler.bind(null, true);
        var changeHandler = handler.bind(null, false);

        elem.on('change', function() {
          scope.$apply( changeHandler );
        });
        scope.$watch('list', setupHandler, true);
      }
    };
  });
}( angular.module('Westfield') ));