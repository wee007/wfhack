( function ( app ) {
  app.directive( 'toggleVisibility', function () {
    // Each trigger / target combination will have a corresponding id.
    var triggerCounter = 0,

    elementID = function () {
      id = 'toggle-visibility-' + triggerCounter;
      triggerCounter++;
      return id;
    },

    toggleVisibility = function ( trigger, target ) {
      if ( target.is( ':visible' ) ) {
        // Hide the target

        // Aria state for trigger
        trigger.attr( 'aria-expanded', false );

        // Change the display of the target
        target.hide();

        // Aria state for target
        target.attr( 'aria-hidden', true );
      } else {
        // Show the target


        // Aria state for the trigger
        trigger.attr( 'aria-expanded', true );

        // Change the display of the target
        target.show();

        // Aria state for target
        target.attr( 'aria-hidden', false );
      }
    };

    return {
     restrict: 'A',

     // The all important 'link' function.
     // Angular invokes this function for every attribute instance of 'toggle-visibility="target"'
     link: function ( scope, trigger, attributes ) {
        var id = attributes['toggleVisibility'],
            target = $( '#' + id );

        // The element that invokes the toggle should have an aria-haspopup
        trigger.attr( 'aria-haspopup', true );

        // Aria ID and labelledby
        id = elementID();
        trigger.attr( 'id', id );
        target.attr( 'aria-labelledby', id );

        // Visibility will be toggled on click / tap
        trigger.on( 'click', function () {
          toggleVisibility( trigger, target );
        });
      }
    }
  });
}( angular.module('Westfield') ));
