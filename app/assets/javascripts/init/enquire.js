/* Do stuff on `$(window).resize` via Enquire library */
$(function() {
  var telLinks = $('a[href^="tel:"]'),
      mq = 'all and (min-width: 40.0625em)';

  enquire.register(mq, {

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

      // Add a non-palm class as a mediaquery utility
      $('html').addClass('non-palm');

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

      // Remove non-palm class
      $('html').removeClass('non-palm');
    }

  }, true);
});
