/*
 * Toggle header menu for palm sized viewports plugin
 * @desc        used to toggle the header menu for palm sized viewports
 * @initialise  $('.js-menu-toggle').toggleMenu();
 */

$.fn.toggleMenu = function() {

    // Set variables
    var toogleBtn = $('.js-menu-toggle-btn'),
        toggleBtnTxt = toogleBtn.children('.btn--menu-toggle__txt'),
        menu = $(this),
        search = $('.js-search-toggle'),
        header = $('.header');

    // Toggle on click event
    $(toogleBtn).toggleClick(
        // Expanded state
        function() {
            menu.toggleClass('is-expanded');
            $(this).toggleClass('is-expanded');
            toggleBtnTxt.html('Close menu');
            // Remove the global search
            if (search.hasClass('is-expanded')) {
                search.removeClass('is-expanded');
            }
            // Toggle fixed positiong so menu can be scrolled/swiped and set focus to top of viewport
            header.toggleClass('is-header-unfixed');
            $(window).scrollTop(0)
        },
        // Collapsed state
        function() {
            menu.toggleClass('is-expanded');
            $(this).toggleClass('is-expanded');
            toggleBtnTxt.html('Open menu');
            // Remove the global search
            if (search.hasClass('is-expanded')) {
                search.removeClass('is-expanded');
            }
            // Toggle fixed positiong so menu can be scrolled/swiped
            header.toggleClass('is-header-unfixed');
    })
}