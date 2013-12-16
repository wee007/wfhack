/* Focus in the global search input when it's opened via the toggle trigger */
$(function() {
  $('.js-search-toggle').click(function() {
    if($('.js-header-search.is-active').length) {
      $('.js-header-search input[type="search"]').focus();
    }
  });
});