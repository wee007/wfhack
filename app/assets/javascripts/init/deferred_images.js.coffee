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

  class DeferredImageLoader

    attrs: ['src', 'alt', 'itemprop']

    constructor: (@el, @img = $('<img>')) ->

    load: ->
      @setAttributes()
      @img.on('load', @success)
      @img.on('error', @error)
      @img.hide()
      @el.after(@img)

    setAttributes: ->
      for attr in @attrs
        if @el.data("image-#{attr}")
          @img.attr(attr, @el.data("image-#{attr}"))
          @el.removeAttr("data-image-#{attr}")

    success: =>
      @el.remove()
      @img.show()

    error: =>
      @el.remove()
      @img.remove()

  class DeferredImages

    constructor: (container, @options = {}) ->
      @container = $(container)
      if @options.matchMedia
        window.enquire.register(@options.matchMedia, {
          match: @attachListeners
          unmatch: @detachListeners
        }, true)
      else
        @attachListeners()

    loadVisibleImages: =>
      visibleImages = $('[data-image-src]', @container).map(@visibleIn(@container))
      visibleImages.each -> new DeferredImageLoader(@).load()

    visibleIn: (container) ->
      offset = container.offset()
      top = offset.top
      bottom = offset.top + container.height()
      return ->
        el = $(@)
        offset = el.offset()
        if (offset.top + el.height()) > top && offset.top < bottom
          return el
        else
          return null

    attachListeners: =>
      @loadVisibleImages()
      @container.on('scroll.deferred-logos', =>
        clearTimeout(@timeout)
        @timeout = setTimeout(@loadVisibleImages, 100)
      )

    detachListeners: =>
      clearTimeout(@timeout)
      @container.off('.deferred-logos')

  deferImages = (container, options) ->
    new DeferredImages(container, options)

  $.fn[name] = (options) ->
    $(@).each ->
      if deferred.state() == 'resolved'
        deferImages(@, options)
      else
        self = @
        deferred.then -> deferImages(self, options)
