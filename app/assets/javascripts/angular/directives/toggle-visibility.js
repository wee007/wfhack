( function ( app ) {
  app.directive( 'toggleVisibility', ['$rootScope', '$document', function ($rootScope, $document) {
    $rootScope.activeTVTarget = undefined;

    $rootScope.$watch( 'activeTVTarget', function ( value, prevValue ) {
      if ( value == prevValue ) { return; } // on init
      if ( prevValue ) { deactivateTarget( prevValue ); } // close prevTarget
      activateTarget( value ); // activate new target
    });

    // Clicking outside will close all toggleVisibility targets
    $document.bind( 'click', function ( event ) { close(); });

    // Escape key will close all toggleVisibility targets
    $document.bind( 'keydown', function ( event ) {
      if ( event.keyCode == 27 ) { close(); }
    });

    // Each trigger / target combination will have a corresponding id.
    var triggerCounter = 0,
        activeClass = 'is-active',

    // Closes all instances of toggleVisibility
    close = function () {
      $rootScope.$apply(function () {
        $rootScope.activeTVTarget = undefined;
      });
    },

    // Update the active target
    open = function ( id ) {
      $rootScope.$apply(function () {
        $rootScope.activeTVTarget = id;
      });
    },

    triggers = function ( targetID ) {
      return $( "[aria-controls=" + targetID + "]" );
    },

    target = function ( targetID ) {
      return $( "#" + targetID )
    },

    // Hide the target, set appropriate ARIA
    deactivateTarget = function ( targetID ) {
      triggers( targetID ).attr( 'aria-expanded', false ).removeClass( activeClass );
      target( targetID ).removeClass( activeClass );
    },

    // Show the target, set appropriate ARIA
    activateTarget = function ( targetID ) {
      triggers( targetID ).attr( 'aria-expanded', true ).addClass( activeClass );
      target( targetID ).addClass( activeClass );
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
        trigger.attr( 'aria-expanded', false );

        // Visibility will be toggled on click / tap
        trigger.bind( 'click', function ( e ) {
          ( $rootScope.activeTVTarget == id ) ? close() : open(id);
          e.stopPropagation();
        });

        // Allow the user to click inside the target
        target.bind( 'click', function( e ) { e.stopPropagation(); });
      }
    }
  }]);
}( angular.module('Westfield') ));
