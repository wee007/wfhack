// Modernizr included in HTML
// All other requires are handled here


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


//= require ./support/custom-modernizr-tests

// External dependencies, handled via Bower.
// See: https://gist.github.com/benschwarz/5874031/


    // Not palm size viewport
//= require jquery
//= require jquery-ujs/src/rails.js

// Required for slider
//= require jquery-ui/ui/jquery.ui.widget
//= require jquery-ui/ui/jquery.ui.mouse
//= require jquery-ui/ui/jquery.ui.slider

//= require isotope/jquery.isotope.js
//= require angular
//= require enquire
//= require unveil/jquery.unveil.js

//= require ./vendor/jquery.isotope.gutters

// Conditional support
//= require ./support/matchmedia
//= require ./support/svg
//= require ./support/input-placeholder



// When you need to initialize any jquery plugins or general global stuff,
// do it in an init/initName file
//= require_tree ./jquery-extensions
//= require ./init/toggle
//= require ./init/header
//= require ./init/unveil
//= require ./init/tiles
//= require ./init/enquire-blackberry


