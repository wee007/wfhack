/* Focus in the global search input when it's opened via the toggle trigger */
function globalSearchFocus() {
  var headerSearchInput = $('.js-header-search input[type="search"]');

  $('.js-search-toggle').click(function() {
    if($('.js-header-search.is-active').length) {
      headerSearchInput.focus();
    } else {
      headerSearchInput.blur();
    }
  });
}