// Note: we have to remove some ARIA attr's e.g. `aria-hidden` because some of the elements this directive is applied too only needs to be applied at certain viewports so until we have some way of applying this directive conditionally based on media queries we have to remove.

( function ( app ) {
  app.directive( 'toggleVisibility', ['$document', function ($document) {
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
      target.removeClass( activeClass );
    },

    // Show the target
    show = function ( trigger, target ) {

      // ARIA for trigger
      trigger.attr( 'aria-expanded', true );

      // Toggle the active class
      trigger.addClass( activeClass );
      target.addClass( activeClass );
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
