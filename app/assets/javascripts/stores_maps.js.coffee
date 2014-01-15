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

  setup: =>
    body = $('body')
    body.on('click', '.is-list-view .js-stores-maps-toggle-btn', @show)
    body.on('click', '.is-map-view .js-stores-maps-toggle-btn', @hide)
    self = @
    body.on('click', '[data-store-id]', ->
      self.show()
      el = $(@)
      setTimeout((-> self.store(el.data('store-id'))), 0)
      false
    )

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

    # FIXME: Webkit doesn't redraw the page correctly unless we force it
    $('.js-stores-maps-toggle-wrap').width()

  store: (storeId) ->
    @map.setTarget(storeId).showLevel().zoom().highlight().detail()

$('.js-fastclick').each -> FastClick.attach(@)
@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
