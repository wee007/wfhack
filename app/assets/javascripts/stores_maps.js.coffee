#= require flexslider/jquery.flexslider
#= require map/responsive_map
#= require fastclick

class StoreMapPage

  constructor: ->
    @map = new map.ResponsiveMap {
      breakpoint: 'all and (min-width: 64em)'
      palm: offset: x: 0.5, y: 0.5, zoom: 0.6
      nonPalm: offset: x: 0.75, y: 0.5, zoom: 0.7
    }

  loadComplete: =>
    $ ->
      if window.storeMapPageReady
        setTimeout((->
          storeMapPageReady()
          delete storeMapPageReady
        ), 0)

  setup: =>
    body = $('body')
    body.on('click', '.is-list-view .js-stores-maps-toggle-btn', @show)
    body.on('click', '.is-map-view .js-stores-maps-toggle-btn', @hide)
    # Micello hijacks clicks on the store map for touch devices
    # so listen for touchstart event which is not hijacked and send user to the url manually
    body.on 'touchstart', '.js-touchlink', ->
      window.location.href = $(@).attr 'href'
    self = @
    body.on('click', '[data-store-id]', ->
      self.show()
      el = $(@)
      setTimeout((-> self.store(el.data('store-id'))), 0)
      false
    )
    @loadComplete()

  show: =>
    @updateGUI @map.show()
    false

  hide: =>
    @updateGUI @map.hide()
    false

  updateGUI: (viewingMap) ->
    $('.js-stores-maps-toggle-btn').toggleClass('is-expanded', viewingMap)
    $('.js-stores-maps-toggle-btn-txt').html(if viewingMap then 'list' else 'map')
    $('.js-stores-maps-toggle-wrap').toggleClass('is-map-view', viewingMap)
    $('.js-stores-maps-toggle-wrap').toggleClass('is-list-view', !viewingMap)

    # Webkit doesn't redraw the page correctly unless we force it
    # This should have minimal visual impact while forcing a redraw
    container = $('.js-stores-maps-toggle-wrap')
    container.css 'width', '-=1px'
    container.css 'width', '+=1px'

  store: (storeId) ->
    @map.setTarget(storeId).showLevel().zoom().highlight().detail()

  pinStores: ->
    getId = -> $(@).data 'store-id'
    ids = $('a[data-store-id]').map getId
    storeMapPage.map.pinStores(ids, true, true)

$('.js-fastclick').each -> FastClick.attach(@)
@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
