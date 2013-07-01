(function ( $ ) {
  var telLinks = $('a[href^="tel:"]'),
      mq = 'all and (min-width: 40.0625em)';


  /* --Do stuff on `$(window).resize` via Enquire library-- */
  enquire.register(mq, {

    deferSetup: true,

    setup: function() {

      // Conditionally load scripts
      /*$.getScript('/Cheetah/js/modules/conditionally-loaded.js', function() {
          $('.js-menu-accessible-ddown').accessibleDropDownMenu();
      }, true);*/

    },

    // Not palm size viewport
    match: function() {

      // Test
      //$('body').css('background', 'gold');

      // Disable focus and click events for `tel` links
      telLinks.attr('tabindex', '-1');
      telLinks.click(function(e) {
          e.preventDefault();
      });

      // Run 'Calculate the height of the fixed header' plugin
      $('.header').calculateHeaderHeight();

    },

    // Palm size viewport
    unmatch: function() {

      // Test
      //$('body').css('background', 'hotpink');

      // Enable focus and click events for `tel` links
      telLinks.removeAttr('tabindex');
      telLinks.unbind('click');

      // Run 'Calculate the height of the fixed header' plugin
      $('.header').calculateHeaderHeight();

    }

  }, true);
}( jQuery ));