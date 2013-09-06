( function ( app ) {
  app.directive( 'toggleVisibility', ['$document', function ($document) {
    // Each trigger / target combination will have a corresponding id.
    var triggerCounter = 0,

    elementID = function () {
      id = 'toggle-visibility-' + triggerCounter;
      triggerCounter++;
      return id;
    },

    hide = function ( trigger, target ) {
      // Hide the target

      // Aria state for trigger
      trigger.attr( 'aria-expanded', false );

      trigger.removeClass( 'is-active' );
      target.removeClass( 'is-active' );

      // Aria state for target
      target.attr( 'aria-hidden', true );
    },

    show = function ( trigger, target ) {
      // Show the target

      // Aria state for the trigger
      trigger.attr( 'aria-expanded', true );

      trigger.addClass( 'is-active' );
      target.addClass( 'is-active' );

      // Aria state for target
      target.attr( 'aria-hidden', false );
    },

    toggleVisibility = function ( trigger, target ) {
      if ( target.is( ':visible' ) ) {
        hide( trigger, target );
      } else {
        show( trigger, target );
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

        // Aria state for target
        target.attr( 'aria-hidden', true );

        // Aria ID and labelledby
        id = elementID();
        trigger.attr( 'id', id );
        target.attr( 'aria-labelledby', id );

        // Visibility will be toggled on click / tap
        trigger.bind( 'click', function ( e ) {
          toggleVisibility( trigger, target );
          e.stopPropagation();
        });

        // Click outside
        $document.bind( 'click', function ( event ) {
          hide( trigger, target );
        });

        target.bind( 'click', function( e ) {
          e.stopPropagation();
        });

        // Escape key
        $document.bind( 'keydown', function ( event ) {
          if ( event.keyCode == 27 ) { hide( trigger, target ); }
        })
      }
    }
  }]);
}( angular.module('Westfield') ));
