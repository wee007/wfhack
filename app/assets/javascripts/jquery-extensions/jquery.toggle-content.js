/*
* Toggle content plugin
* @desc         used to toggle content via expanding and collapsing
* @initialise   single instance: $('.js-toggle-content').toggleContent();
                multiple instance: $('.js-toggle-content').each(function() {$(this).toggleContent();});
* @css          needs to use the 'Toggle Content' abstraction
*/
$.fn.toggleContent = function(options, toggleBtnWrap, toggleBtnTrigger, btnTxtOpen, btnTxtClose) {

  // Setup defaults
  var defaults = {
      // Wrapper around button element
      toggleBtnWrap: $('<div class="toggle-content--btn"></div>'),
      // HTML for button element
      toggleBtnTrigger: $('<button type="button" class="btn btn--full btn--expand-collapse"></button>'),
      // Text you want in the button *before* toggling
      btnTxtOpen: 'Expand <span aria-hidden="true" class="icon icon--arrow-down-full icon--lrg"></span>',
      // Text you want in the button *after* toggling
      btnTxtClose: 'Collapse <span aria-hidden="true" class="icon icon--arrow-up-full icon--lrg"></span>',
      // Where you want to inject the button. Values: "insertAfter" || "insertBefore"
      btnPos: 'insertAfter',
      // Button class when content is hidden and button indicates it can be opened
      btnOpenClass: 'is-collapsed',
      // Button class when content is shown and button indicates it can be closed
      btnCloseClass: 'is-expanded',
      // Toggle speed
      toggleSpeed: 100,
      // Shown by default
      shownByDefault: false
  }

  return $(this).each(function() {

    // Merge defaults and options
    var settings = $.extend(defaults, options),
        toggleContentWrap = $(this),
        toggleBtnWrap = settings.toggleBtnWrap,
        toggleBtnTrigger = settings.toggleBtnTrigger,
        btnTxtOpen = settings.btnTxtOpen,
        btnTxtClose = settings.btnTxtClose,
        btnPos = settings.btnPos,
        btnOpenClass = settings.btnOpenClass,
        btnCloseClass = settings.btnCloseClass,
        toggleSpeed = settings.toggleSpeed,
        shownByDefault = settings.shownByDefault;

    // Show content
    showContent = function(toggleBtnTrigger) {
      toggleBtnTrigger.removeClass(btnOpenClass).addClass(btnCloseClass).html(btnTxtClose);
      toggleContentWrap.show().attr('aria-expanded', 'true');
    }

    // Hide content
    hideContent = function(toggleBtnTrigger) {
      toggleBtnTrigger.removeClass(btnCloseClass).addClass(btnOpenClass).html(btnTxtOpen);
      toggleContentWrap.hide().attr('aria-expanded', 'false');
    }

    // When clicking on the toggle button
    toggleBtnTrigger.click(function() {
      if (toggleContentWrap.is(':visible')) {
        toggleContentWrap.slideUp(toggleSpeed).attr('aria-expanded', 'false');
        toggleBtnTrigger.removeClass(btnCloseClass).addClass(btnOpenClass).html(btnTxtOpen);
      } else {
        toggleBtnTrigger.removeClass(btnOpenClass).addClass(btnCloseClass).html(btnTxtClose);
        toggleContentWrap.slideDown(toggleSpeed, function() {
          $(this).attr({'aria-expanded' : 'true', 'tabindex' : -1}).focus();
        });
      }
    });

    // Link the toggle button to the toggle content via ARIA `aria-controls` attr using a dynamically generated `id` on the toggle content panel
    var id = Math.floor(Math.random()*100);
    toggleContentWrap.attr('id', 'toggle-content-' + id);
    toggleBtnTrigger.attr('aria-controls', 'toggle-content-' + id);

    // If toggle content is visible by default
    if (shownByDefault) {
      showContent(toggleBtnTrigger);
    } else {
      hideContent(toggleBtnTrigger);
    }

    // Create the toggle button (wrapper + button trigger)
    var toggleBtn = toggleBtnWrap.append(toggleBtnTrigger);

    // Inject the toogle button
    switch(btnPos) {
      // Insert after the hidden content
      case('insertAfter') :
        toggleBtn.insertAfter(toggleContentWrap);
        break;
      // Insert before the hidden content
      case ('insertBefore'):
        toggleBtn.insertBefore(toggleContentWrap);
        break;
    }

  })
}