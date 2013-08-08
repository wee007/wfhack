window.deferCall = ->
  # If any of the tests are falsey a timeout is queued to call the function again
  for test in arguments
    if !test
      setTimeout(deferCall.caller, 100)
      return true
  false

do initialiseDeferredLogos = ->
  # Deferres this function until enquire is avaliable
  return if deferCall(window.enquire)

  timeout = 0

  loadImages = ->
    list = $('.js-stores-maps-toggle-listing-detail')
    offset = list.offset()
    height = list.height()
    top = offset.top
    bottom = offset.top + height
    $('img[data-image]', list).each ->
      img = $(this)
      offset  = img.offset()
      height = img.height()
      if (offset.top + height) > top && offset.top < bottom
        img.attr('src', img.data('image')).removeAttr('data-image')

  attachDeferredListener = ->
    loadImages()
    $('.js-stores-maps-toggle-listing-detail').on('scroll.deferred-logos', ->
      clearTimeout(timeout)
      timeout = setTimeout(loadImages, 100)
    )

  detachDeferredListener = ->
    clearTimeout(timeout)
    $('.js-stores-maps-toggle-listing-detail').off('.deferred-logos')

  $ ->
    enquire.register("all and (min-width: 40.0625em)", {
      match: attachDeferredListener
      unmatch: detachDeferredListener
    }, true)
