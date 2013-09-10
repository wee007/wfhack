/*
 * Closes the site search in the site wide header
 * @desc        site search uses the generic Angular toggle visibility directive but the search is unique in that it has a close button so we need extra JavaScript to handle that
 * @initialise  $('.js-site-search-close').closeSiteSearch();
 */
$.fn.closeSiteSearch = function() {
  this.click(function() {
    $('.header-search-toggle').removeClass('is-active');
  });
}