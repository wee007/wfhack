// Modernizr included in HTML, all other requires are handled here

// External dependencies, handled via Bower. See: https://gist.github.com/benschwarz/5874031/
//= require jquery
//= require script.js/dist/script
//= require matchMedia/matchMedia
//= require matchMedia/matchMedia.addListener
//= require enquire

// Support
//= require ./support/custom-modernizr-tests
//= require ./support/svg
//= require ./support/console-log

// Global 'init' stuff
//= require ./init/enquire
//= require ./init/pin-board
//= require ./init/deferred_images

// jQuery plugins and their initialisers
//= require ./jquery-extensions/jquery.nav-contextual
//= require ./init/nav-contextual
//= require ./jquery-extensions/jquery.table-horizontal-scroll
//= require ./init/table-horizontal-scroll
//= require ./jquery-extensions/jquery.tabs
//= require ./init/tabs
//= require ./vendor/jquery.viewport
//= require ./init/viewport_check

// Angular
//= require ./vendor/angular-head
//= require ./vendor/angular-mobile
//= require ./vendor/angular-sanitize
//= require ./angular/app
//= require_tree ./angular/factories
//= require_tree ./angular/services
//= require_tree ./angular/directives
//= require_tree ./angular/filters
//= require_tree ./angular/controllers

// --Misc--

// Cloudinary (image service)
//= require cloudinary/jquery.cloudinary

// Micello map deferred loader
//= require ./map/deferred_map

// Site wide feedback via JIRA Issue Collector
//= require ./vendor/jira-issue-tracker