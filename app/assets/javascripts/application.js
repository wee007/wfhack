// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// require jquery
// require jquery_ujs
// require turbolinks
// require_tree .

// Pull in author & 3rd party files

//= require ./author/jquery.toggle-click
//= require ./vendor/polyfills/matchMedia
//= require ./author/jquery.toggle-menu
//= require ./author/jquery.toggle-search
//= require ./vendor/enquire
//= require ./vendor/jquery.twitter-bootstrap-dropdown


/* --HELPERS-- */

/*
 * Avoid `console` errors in browsers that lack a console
 * @credit  http://html5boilerplate.com/
 */
(function() {
    var method;
    var noop = function () {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());


/* --GLOBAL VARS-- */

var
// Google map, if we want access 'map' outside of initialize()
//map,
// Get viewport width
viewport = document.body.clientWidth,
// Breakpoints (BP) (these need to match the CSS breakpoints)
BPpalmAlt = 640,
BPpalm    = 'all and (max-width: 40em)',    // 640px
BPlap     = 'all and (min-width: 40.0625em)', // 641px
// Is palm sized viewport
isPalmSizedScreen = (viewport <= BPpalmAlt),
// HTML element
htmlElement = $('html'),
// `tel:` links
telLinks = $('a[href^="tel:"]'),
// Is touch device
isTouch = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
// Is iOS device
isiOS = navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/iPod/i),
// Is old IE
isOldIE = htmlElement.hasClass('old-ie'),
// Is JS enabled
isJS = htmlElement.hasClass('js'),
// Android V2- detection
androidV2 = false,
androidStart = navigator.userAgent.indexOf("Android "),
androidVer = navigator.userAgent.substr(androidStart+8,1),
// Is there SVG support
isSVG = document.implementation.hasFeature('http://www.w3.org/TR/SVG11/feature#Image', '1.1');

// Enable caching for conditionally loading scripts via `getScript`
$.getScript = function(url, callback, cache) {
    $.ajax({
        type: "GET",
        url: url,
        success: callback,
        dataType: "script",
        cache: cache
    });
};

/* --FIRE ON DOM READY-- */
$(function() {

    /* --Conditionally load polyfills-- */

    // HTML5 input placeholder attr
    if (!('placeholder' in $('<input>')[0])) {
        $.getScript('//cdnjs.cloudflare.com/ajax/libs/jquery-placeholder/2.0.7/jquery.placeholder.min.js', function() {
            $('input, textarea').placeholder();
        }, true);
    }


    /* --Run plugins-- */

    // Run 'Toggle menu for palm sized viewports' plugin
    $('.js-menu-toggle').toggleMenu();

    // Run 'Toggle search for palm sized viewports plugin' plugin
    $('.js-search-toggle').toggleSearch();


    /* --DOM lookups-- */


    /* --Tid bits-- */

    // Apply hook for iOS devices
    if (isiOS) {
        htmlElement.addClass('ios');
    }

    // Apply hook for SVG support/non-support
    if (isSVG) {
        htmlElement.addClass('svg');
    } else {
        htmlElement.addClass('no-svg');
    }

    // Replace SVG logo with PNG version for non-supporting browsers (Non JS support: http://www.noupe.com/tutorial/svg-clickable-71346.html - last technique)
    if (!isSVG) {
        $('img[src*="svg"]').attr('src', function() {
            return $(this).attr('src').replace('.svg', '.png');
        });
    }

    // Add hook to `html` if Android V2
    if (androidVer <= 2) {
        androidV2 = true;
    }
    if (androidV2) {
        htmlElement.addClass('androidv2');
    }


    /* --Do stuff on `$(window).resize` via Enquire library-- */
    enquire.register(BPlap, {

        deferSetup: true,

        setup: function() {

            // Conditionally load scripts
            /*$.getScript('/Cheetah/js/modules/conditionally-loaded.js', function() {
                $('.js-menu-accessible-ddown').accessibleDropDownMenu();
            }, true);*/

        },

        // Not palm size viewport
        match: function() {

            // Test
            //$('body').css('background', 'gold');

            // Disable focus and click events for `tel` links
            telLinks.attr('tabindex', '-1');
            telLinks.click(function(e) {
                e.preventDefault();
            });

        },

        // Palm size viewport
        unmatch: function() {

            // Test
            //$('body').css('background', 'hotpink');

            // Enable focus and click events for `tel` links
            telLinks.removeAttr('tabindex');
            telLinks.unbind('click');

        }

    }, true).listen();

});
