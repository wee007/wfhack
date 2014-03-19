// Modernizr included in HTML, all other requires are handled here

// External dependencies, handled via Bower. See: https://gist.github.com/benschwarz/5874031/
//= require jquery
//= require script.js/dist/script
//= require matchMedia/matchMedia
//= require matchMedia/matchMedia.addListener
//= require enquire

// Support
//= require ./support/custom-modernizr-tests
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
//= require ./init/social-share

// Angular
//= require angular
//= require angular-touch
//= require angular-sanitize
//= require angular-route

//= require ./angular/app
//= require_tree ./angular/factories
//= require_tree ./angular/services
//= require_tree ./angular/directives
//= require_tree ./angular/filters
//= require_tree ./angular/controllers

// --Misc--

// Micello map
//= require ./map/deferred_map
//= require ./map/micello_hijack_event_fix

// Site wide feedback via JIRA Issue Collector
//= require ./vendor/jira-issue-tracker
