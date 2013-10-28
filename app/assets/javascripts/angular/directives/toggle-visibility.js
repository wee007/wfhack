// tab index support:
// all focusable elements get tab-index: -1.
// add up down keyboard events for when the object is shown only
//  that cycle through the focusable elements in the shown target

//aria-controls="id-of-target"

( function ( app ) {
  app.directive( 'toggleVisibility', ['$rootScope', '$document', '$animate', function ($rootScope, $document, $animate) {
    // Each trigger / target combination will have a corresponding id.
    var triggerCounter = 0,
    activeClass = 'is-active';

    elementID = function () {
      id = 'toggle-visibility-' + triggerCounter;
      triggerCounter++;
      return id;
    },

    // Hide the target
    hide = function ( trigger, target ) {

      // ARIA for trigger
      trigger.attr( 'aria-expanded', false );

      // Toggle the active class
      trigger.removeClass( activeClass );

      $animate.addClass( target, 'is-active-animate-leave', function () {
        $animate.removeClass( target, 'is-active-animate', function () {
          setTimeout( function () {
            $animate.removeClass( target, 'is-active-animate-leave is-active' );
          }, 250)
        });
      });
    },

    // Show the target
    show = function ( trigger, target ) {

      // ARIA for trigger
      trigger.attr( 'aria-expanded', true );

      // Toggle the active class
      trigger.addClass( activeClass );

      $animate.addClass( target, 'is-active', function () {
        $animate.addClass( target, 'is-active-animate' );
      });
    },

    // Toggle visibility
    toggleVisibility = function ( trigger, target ) {
      if ( target.is( ':visible' ) ) {
        hide( trigger, target );
      } else {
        show( trigger, target );
      }
    };

    return {
     restrict: 'A',

     // The all important 'link' function
     // Angular invokes this function for every attribute instance of `toggle-visibility="target"`
     link: function ( scope, trigger, attributes ) {
        var id = attributes['toggleVisibility'],
            target = $( '#' + id );

        // ARIA for trigger
        trigger.attr( 'aria-haspopup', true );
        trigger.attr( 'aria-controls', id );

        // ID attr and target ARIA `aria-labelledby`
        id = elementID();
        trigger.attr( 'id', id );

        // Visibility will be toggled on click / tap
        trigger.bind( 'click', function ( e ) {
          toggleVisibility( trigger, target );
          e.stopPropagation();
        });

        // Clicking outside will close it
        $document.bind( 'click', function ( event ) {
          hide( trigger, target );
        });

        target.bind( 'click', function( e ) {
          e.stopPropagation();
        });

        // Escape key will close it
        $document.bind( 'keydown', function ( event ) {
          if ( event.keyCode == 27 ) { hide( trigger, target ); }
        });
      }
    }
  }]);
}( angular.module('Westfield') ));
