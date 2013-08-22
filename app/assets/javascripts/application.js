// Modernizr included in HTML
// All other requires are handled here

//= require ./support/custom-modernizr-tests

// External dependencies, handled via Bower.
// See: https://gist.github.com/benschwarz/5874031/

//= require jquery
//= require script.js/dist/script
//= require ./support/modernizr-load

// Conditional support
//= require ./support/mediaqueries
//= require ./support/svg
//= require ./support/input-placeholder

//= require isotope/jquery.isotope
//= require ./vendor/jquery.isotope.responsive
//= require ./vendor/bootstrap-dropdown
//= require ./vendor/jquery.tabs

// If console is unimplemented in a browser, and someone
// accidently leaves a log, debug, error, etc the browser won't throw & die.
//= require ./support/console-log

// When you need to initialize any jquery plugins or general global stuff,
// do it in an init/initName file
//= require_tree ./jquery-extensions
//= require ./init/toggle
//= require ./init/tiles
//= require ./init/tabs
//= require ./init/deferred_images
//= require ./init/table-horizontal-scroll

//= require angular
//= require angular-touch
//= require angular-sanitize

//= require ./angular/app
//= require_tree ./angular/

// Map deferred loader
//= require ./map/deferred_map
