/* Focus in the global search input when it's opened via the toggle trigger */
$(function() {
  var isHeaderSearchActive = $('.js-header-search.is-active');
  var headerSearchInput = $('.js-header-search input[type="search"]');

  $('.js-search-toggle').click(function() {
    if(isHeaderSearchActive.length) {
      headerSearchInput.focus();
    } else {
      headerSearchInput.blur();
    }
  });
});