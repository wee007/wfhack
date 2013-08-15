window.deferCall = ->
  # If any of the tests are falsey a timeout is queued to call the function again
  for test in arguments
    if !test
      setTimeout(deferCall.caller, 100)
      return true
  false

$ = window.jQuery
name = 'deferImages'

do ($, name) ->

  deferred = $.Deferred()
  deferImages = null

  do ->
    # Deferres this function until enquire is avaliable
    return if deferCall(window.enquire)
    deferred.resolve()

  class DeferredImages

    constructor: (@containers, @options = {}) ->
      if @options.matchMedia
        window.enquire.register(@options.matchMedia, {
          match: @attachListeners
          unmatch: @detachListeners
        }, true)
      else
        @attachListeners()

    loadVisibleImages: =>
      $(@containers).each ->
        container = $(@)
        offset = container.offset()
        containerTop = offset.top
        containerBottom = offset.top + container.height()
        $('[data-image-src]', container).each ->
          el = $(@)
          offset = el.offset()
          if (offset.top + el.height()) > containerTop && offset.top < containerBottom
            img = $('<img>')
            for attr in ['src', 'alt', 'itemprop']
              img.attr(attr, el.data("image-#{attr}")) if el.data("image-#{attr}")
            el.removeAttr('data-image-src')
            img.on('load', do (el) -> -> el.remove())
            img.on('error', do (el) -> -> el.add(this).remove())
            el.after(img)

    attachListeners: =>
      @loadVisibleImages()
      $(@containers).on('scroll.deferred-logos', =>
        clearTimeout(@timeout)
        @timeout = setTimeout(@loadVisibleImages, 100)
      )

    detachListeners: =>
      clearTimeout(@timeout)
      $(@containers).off('.deferred-logos')

  deferImages = (containers, options) ->
    new DeferredImages(containers, options)

  $.fn[name] = (options) ->
    if deferred.state() == 'resolved'
      deferImages(@, options)
    else
      self = @
      deferred.then -> deferImages(self, options)
