// Modernizr included in HTML
// All other requires are handled here


//= require ./support/custom-modernizr-tests

// External dependencies, handled via Bower.
// See: https://gist.github.com/benschwarz/5874031/

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
//= require ./init/enquire-blackberry


