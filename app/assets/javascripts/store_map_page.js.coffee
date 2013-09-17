#= require jquery-pjax
#= require map/responsive_map

class StoreMapPage

  constructor: ->
    @map = new map.ResponsiveMap {
      breakpoint: 'all and (min-width: 64em)'
      palm: offset: x: 0.5, y: 0.5
      nonPalm: offset: x: 0.75, y: 0.5
    }

  pjaxComplete: =>
    storeMapPageReady() if window.storeMapPageReady
    delete storeMapPageReady
    $('.js-stores-maps-toggle-btn').off('click').on('click', @toggle)
    self = @
    $('[data-store-id]').off('click').on('click', ->
      self.toggle()
      self.store($(@).data('store-id'))
      console.log('block?')
      false
    )

  setup: =>
    $.pjax.defaults.timeout = 5000
    $(document).pjax('.js-pjax-container a.js-pjax-link', '.js-pjax-container')
    $('.js-pjax-container').on('pjax:end', @pjaxComplete)
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
