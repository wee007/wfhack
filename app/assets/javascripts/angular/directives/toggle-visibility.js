( function ( app ) {
  app.directive( 'toggleVisibility', ['$rootScope', '$timeout', '$document', function ( $rootScope, $timeout, $document ) {


    $rootScope.activeTVTarget = undefined;

    $rootScope.$watch( 'activeTVTarget', function ( value, prevValue ) {
      if ( value == prevValue ) { return; } // on init
      if ( prevValue ) { deactivateTarget( prevValue ); } // close prevTarget
      activateTarget( value ); // activate new target
    });

    // Clicking outside will close all toggleVisibility targets
    $document.bind( 'click', function ( event ) {
      if ($(event.target).parents('.toggle-visibility').length == 0) {
        close();
      }
    });

    // When product filter dropdowns are opened, close this toggle vis widget
    $rootScope.$on( 'product-filter-dropdown-open', function() {
      if ($rootScope.activeTVTarget !== 'filters') {
        $timeout(close, 0);
      }
    });

    window.closeToggleVisibilty = function () {
      close();
    }

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
      return angular.element( "[aria-controls=" + targetID + "]" );
    },

    target = function ( targetID ) {
      return angular.element( "#" + targetID )
    },

    // Hide the target, set appropriate ARIA
    deactivateTarget = function ( targetID ) {
      triggers( targetID ).attr( 'aria-expanded', false ).removeClass( activeClass );
      target( targetID ).removeClass( activeClass );
      target( targetID ).unbind('keydown');
    },

    // Show the target, set appropriate ARIA
    activateTarget = function ( targetID ) {
      triggers( targetID ).attr( 'aria-expanded', true ).addClass( activeClass );
      target( targetID ).addClass( activeClass );
      if (targetID) {
        // Let other dropdowns know that they should close themselves
        $rootScope.$broadcast( 'toggle-visibility-dropdowns');
        SocialShare.closeAll();
      }

      target( targetID ).bind('keydown', function(event) {
        // Escape key closes the target and stops event from bubbling to document
        if ( event.keyCode == 27 ) {
          event.stopPropagation();
          close();
        }
      })
    };

    return {
     restrict: 'A',

     // The all important 'link' function
     // Angular invokes this function for every attribute instance of `toggle-visibility="target"`
     link: function ( scope, trigger, attributes ) {
        var id = attributes['toggleVisibility'],
            target = angular.element( '#' + id );

        // ARIA for trigger
        trigger.attr( 'aria-haspopup', true );
        trigger.attr( 'aria-controls', id );
        trigger.attr( 'aria-expanded', false );

        // Visibility will be toggled on click / tap
        trigger.bind( 'click', function ( e ) {
          ( $rootScope.activeTVTarget == id ) ? close() : open(id);
          e.stopPropagation();
        });
      }
    }
  }]);
}( angular.module('Westfield') ));
