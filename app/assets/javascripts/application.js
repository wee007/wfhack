// Modernizr included in HTML
// All other requires are handled here


//= require ./support/custom-modernizr-tests

// External dependencies, handled via Bower.
// See: https://gist.github.com/benschwarz/5874031/

//= require jquery

// Conditional support
//= require ./support/mediaqueries
//= require ./support/svg
//= require ./support/input-placeholder

//= require isotope/jquery.isotope.js
//= require unveil/jquery.unveil.js
//= require ./vendor/bootstrap-dropdown
//= require ./vendor/jquery.isotope.gutters

// If console is unimplemented in a browser, and someone
// accidently leaves a log, debug, error, etc the browser won't throw & die.
//= require ./support/console-log

// When you need to initialize any jquery plugins or general global stuff,
// do it in an init/initName file
//= require_tree ./jquery-extensions
//= require ./init/toggle
//= require ./init/header
//= require ./init/unveil
//= require ./init/tiles

//= require ./vendor/angular-head
//= require ./vendor/angular-head-route
//= require ./vendor/angular-mobile
//= require ./angular/app
//= require_tree ./angular/
