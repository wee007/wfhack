#= require jquery-pjax
#= require flexslider/jquery.flexslider
#= require map/responsive_map

class StoreMapPage

  constructor: ->
    @map = new map.ResponsiveMap {
      breakpoint: 'all and (min-width: 64em)'
      palm: offset: x: 0.5, y: 0.5
      nonPalm: offset: x: 0.75, y: 0.5
    }

  loading: (state) ->
    # after pjax load has completed the user needs to see the detail
    @toggle() if state && @viewingMap

    $('.js-pjax-container-stores').toggleClass('is-stores-list-detail-loading', state)

  pjaxComplete: =>
    storeMapPageReady() if window.storeMapPageReady
    delete storeMapPageReady

  setup: =>
    $.pjax.defaults.timeout = 5000
    $(document).on('pjax:send', => @loading true)
    $(document).on('pjax:success', => @loading false)
    $(document).pjax('a.js-pjax-link-stores', '.js-pjax-container-stores')
    $('.js-pjax-container-stores').on('pjax:end', @pjaxComplete)
    $('body').on('click touchstart', '.js-stores-maps-toggle-btn', @toggle)
    self = @
    $('body').on('click touchstart', '[data-store-id]', (e) ->
      e.preventDefault() if e
      self.toggle()
      self.store($(@).data('store-id'))
      false
    )
    @pjaxComplete()

  toggle: (e) =>
    e.preventDefault() if e
    @viewingMap = @map.toggle()
    $('.js-stores-maps-toggle-btn').toggleClass('is-expanded', @viewingMap)
    $('.js-stores-maps-toggle-btn-txt').html(if @viewingMap then 'list' else 'map')
    $('.js-stores-maps-toggle-wrap').toggleClass('is-map-view', @viewingMap)

    # FIXME: Webkit doesn't redraw the page correctly unless we force it
    $('.js-stores-maps-toggle-wrap').width()

  store: (storeId) ->
    @map.setTarget(storeId).showLevel().zoom().highlight().detail()

@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
