/* Do stuff on `$(window).resize` via Enquire library */
$(function() {
  var telLinks = $('a[href^="tel:"]'),
      mq = 'all and (min-width: 40.0625em)';

  enquire.register(mq, {

    // Not palm size viewport
    match: function() {

      // Disable focus and click events for `tel` links
      telLinks.attr('tabindex', '-1');
      telLinks.click(function(e) {
          e.preventDefault();
      });

      // Add a non-palm class as a mediaquery utility
      $('html').addClass('non-palm');

    },

    // Palm size viewport
    unmatch: function() {

      // Enable focus and click events for `tel` links
      telLinks.removeAttr('tabindex');
      telLinks.unbind('click');

      // Remove non-palm class
      $('html').removeClass('non-palm');
    }

  }, true);
});
