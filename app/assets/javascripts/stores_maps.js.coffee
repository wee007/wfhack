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
    $('body').on('click.map-micello', '.js-stores-maps-toggle-btn', @toggle)
    self = @
    $('body').on('click.map-micello', '[data-store-id]', ->
      self.toggle()
      self.store($(@).data('store-id'))
      false
    )
    @pjaxComplete()

  toggle: =>
    visible = @map.toggle()
    $('.js-stores-maps-toggle-btn').toggleClass('is-expanded', visible)
    $('.js-stores-maps-toggle-btn__txt').html(if visible then 'list' else 'map')
    $('.js-stores-maps-toggle-wrap').toggleClass('is-map-view', visible)

  store: (storeId) ->
    @map.setTarget(storeId).showLevel().zoom().highlight().detail()

@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
