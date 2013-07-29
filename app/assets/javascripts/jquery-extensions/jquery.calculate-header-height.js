/*
 * Calculate the height of the fixed header
 * @desc        used to push the main content container (`main`) down so it doesn't sit underneath the fixed header
 * @initialise  $('.header').calculateHeaderHeight();
 */
$.fn.calculateHeaderHeight = function() {

  // Set variables
  var header = $(this),
      headerHeight = $(this).height();

  // Only apply when header is fixed
  if (!$(header).hasClass('is-header-hero')) {
    $('.header-height-ghost').height(headerHeight);
  }
};