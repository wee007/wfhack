/*
 * Toggle search for palm sized viewports plugin
 * @desc        used to toggle the global header search for palm sized viewports
 * @initialise  $('.js-search-toggle').toggleSearch();
 */
$.fn.toggleSearch = function() {

    // Set variables
    var toogleBtn = $('.js-search-btn-toggle'),
        toggleBtnTxt = toogleBtn.children('.hide-visually'),
        search = $(this),
        searchContainer = $(this).find('.search-mini'),
        menu = $('.js-menu-toggle'),
        header = $('.header');

    // Toggle on click event
    $(toogleBtn).toggleClick(
        // Expanded state
        function() {
            search.toggleClass('is-expanded');
            $(this).toggleClass('is-expanded');
            toggleBtnTxt.html('Close site search');
            // Remove the header menu and restore header `position: fixed`
            if (menu.hasClass('is-expanded')) {
                menu.removeClass('is-expanded');
                //header.removeClass('is-header-unfixed');
            }
            // Set focus to the search form so screen readers and keyboard users can jump to it as the search form is not directly after the search toggle button
            searchContainer.attr('tabindex', -1).focus();
        },
        // Collapsed state
        function() {
            search.toggleClass('is-expanded');
            $(this).toggleClass('is-expanded');
            toggleBtnTxt.html('Open site search');
            // Remove the header menu and restore header `position: fixed`
            if (menu.hasClass('is-expanded')) {
                menu.removeClass('is-expanded');
                //header.removeClass('is-header-unfixed');
            }
    })
}