/* Do stuff on `$(window).resize` via Enquire library */
$(function() {
  var telLinks = $('a[href^="tel:"]'),
      mqNonPalm = 'all and (min-width: 40.0625em)';

  // Do stuff between palm and non-palm breakpoints
  enquire.register(mqNonPalm, {

    // Not palm size viewport
    match: function() {

      // Disable focus and click events for `tel` links
      telLinks.attr('tabindex', '-1');
      telLinks.click(function(e) {
          e.preventDefault();
      });

      // Add a non-palm class as a mediaquery utility
      $('html').addClass('non-palm');

      // Run 'Calculate the height of the fixed header' plugin
      $('.header').calculateHeaderHeight();
    },

    // Palm size viewport
    unmatch: function() {

      // Enable focus and click events for `tel` links
      telLinks.removeAttr('tabindex');
      telLinks.unbind('click');

      // Remove non-palm class
      $('html').removeClass('non-palm');

      // Run 'Calculate the height of the fixed header' plugin
      $('.header').calculateHeaderHeight();
    }

  }, true);
});
