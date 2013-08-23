/* Do stuff on `$(window).resize` via Enquire library */
$(function() {
  var telLinks = $('a[href^="tel:"]'),
      mqNonPalm = 'all and (min-width: 40.0625em)',
      mqLapLrg = 'all and (min-width: 56.3125em)';

  // Do stuff between palm and non-palm breakpoints
  enquire.register(mqNonPalm, {

    // Not palm size viewport
    match: function() {

      // Disable focus and click events for `tel` links
      telLinks.attr('tabindex', '-1');
      telLinks.click(function(e) {
          e.preventDefault();
      });

      // Add a `non-palm` class as a mediaquery utility
      $('html').addClass('non-palm');
    },

    // Palm size viewport
    unmatch: function() {

      // Enable focus and click events for `tel` links
      telLinks.removeAttr('tabindex');
      telLinks.unbind('click');

      // Remove `non-palm` class
      $('html').removeClass('non-palm');
    }

  }, true);

  // Do stuff between lap large and lap large below breakpoints
  enquire.register(mqLapLrg, {

    // Lap large size viewport
    match: function() {

      // Add a `lap-lrg` class as a mediaquery utility
      $('html').addClass('lap-lrg');
    },

    // Lap large and below viewport
    unmatch: function() {

      // Remove `lap-lrg` class
      $('html').removeClass('lap-lrg');
    }

  }, true);
});
