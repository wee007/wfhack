((app) ->
  app.directive 'wngDialog', ['$rootScope', '$timeout', '$document', ($rootScope, $timeout, $document) ->

    # Use jquery instead of angular's jqLite do we can use wrapInner
    body = jQuery('body')
    main = $('[role="main"]')
    header = $('[role="banner"]')

    isDialogOpen = false
    dialog = null

    close = ->
      isDialogOpen = false
      dialog?.attr 'aria-hidden', true

      dialog = null

      body.removeClass 'is-dialog-active'

      main.attr 'aria-hidden', false
      header.attr 'aria-hidden', false

      jQuery('.dialog-prevent-overflow-x').children().unwrap();

      if Modernizr.localstorage
        sessionStorage.viewedDialog = true

    open = (element) ->
      isDialogOpen = true
      dialog = element

      dialog.attr 'aria-hidden', false

      body.addClass 'is-dialog-active'

      main.attr 'aria-hidden', true
      header.attr 'aria-hidden', true

      body.wrapInner '<div class="dialog-prevent-overflow-x"></div>'

      keepFocus(element.get(0))

    # From https://gist.github.com/drublic/5899658
    tabbableElements = 'a[href], area[href], input:not([disabled]),' + 'select:not([disabled]), textarea:not([disabled]),' + 'button:not([disabled]), iframe, object, embed, *[tabindex],' + '*[contenteditable]'
    keepFocus = (context) ->

      allTabbableElements = context.querySelectorAll(tabbableElements)
      firstTabbableElement = allTabbableElements[0]
      firstTabbableElement.focus()

      lastTabbableElement = allTabbableElements[allTabbableElements.length - 1]
      keyListener = (event) ->
        if isDialogOpen
          keyCode = event.which or event.keyCode # Get the current keycode

          # Polyfill to prevent the default behavior of events
          event.preventDefault = event.preventDefault or ->
            event.returnValue = false

          # If it is TAB
          if keyCode is 9

            # Move focus to first element that can be tabbed  Shift if isnt used
            if event.target is lastTabbableElement and not event.shiftKey
              event.preventDefault()
              firstTabbableElement.focus()

            # Move focus to last element that can be tabbed if Shift is used
            else if event.target is firstTabbableElement and event.shiftKey
              event.preventDefault()
              lastTabbableElement.focus()

      $(context).bind 'keydown', keyListener


    # Escape key will close all dialog targets
    $document.on 'keydown', (event) ->
      close()  if event.keyCode is 27

    restrict: 'A'

    # The all important 'link' function
    # Angular invokes this function for every attribute instance of dialog attribute
    link: (scope, element, attributes) ->
      isAlertDialog = element.hasClass('js-dialog-alert')
      if isAlertDialog and
          Modernizr.localstorage and
          !sessionStorage.viewedDialog
        open(element)
      else
        close()

      dialog?.find('.js-dialog-close').bind 'click', ->
        close()

  ]
) angular.module('Westfield')