/*
 * Calculate the height of the 'Stores' filter
 * @desc        used to push the stores list down so it doesn't sit underneath the stores filter
 * @initialise  $('.stores-maps__listing-detail').calculateHeaderHeight();
 */
$.fn.calculateStoresFilterHeight = function() {

  // Set variables
  var storesFiltersHeight = $(this).outerHeight();

  // Only apply when header is fixed
  $('.stores-maps__listing-detail').css('top', storesFiltersHeight);
};