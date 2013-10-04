// Modernizr included in HTML
// All other requires are handled here

//= require ./support/custom-modernizr-tests

// External dependencies, handled via Bower.
// See: https://gist.github.com/benschwarz/5874031/

//= require jquery
//= require script.js/dist/script

//= require matchMedia/matchMedia
//= require matchMedia/matchMedia.addListener
//= require enquire

// Conditional support
//= require ./support/svg
//= require ./support/string

//= require ./vendor/jquery.tabs

// If console is unimplemented in a browser, and someone accidently leaves a log, debug, error, etc the browser won't throw & die.
//= require ./support/console-log

// When you need to initialize any jquery plugins or general global stuff,
// do it in an init/initName file
//= require_tree ./jquery-extensions
//= require ./init/enquire
//= require ./init/pin-board
//= require ./init/tabs
//= require ./init/deferred_images
//= require ./init/table-horizontal-scroll
//= require ./init/nav-contextual

//= require ./vendor/angular-head
//= require ./vendor/angular-mobile
//= require ./vendor/angular-sanitize
//= require ./angular/app
//= require_tree ./angular/factories
//= require_tree ./angular/services
//= require_tree ./angular/directives
//= require_tree ./angular/filters
//= require_tree ./angular/controllers

//= require cloudinary/jquery.cloudinary

// Map deferred loader
//= require ./map/deferred_map
