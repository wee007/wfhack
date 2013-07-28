( function ( app ) {
  app.directive( 'toggleVisibility', function () {
    return {
     restrict: 'A',
     link: function ( scope, element, attributes ) {
        var id = attributes['toggleVisibility'],
            target = $( '#' + id ),

        toggleVisibility = function () {
          target.is( ':visible' ) ? target.hide() : target.show();
        };

        element.on( 'click', toggleVisibility );
      }
    }
  });
}( angular.module('Westfield') ));
