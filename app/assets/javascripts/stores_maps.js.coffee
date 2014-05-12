#= require jquery-pjax
#= require flexslider/jquery.flexslider
#= require map/responsive_map
#= require fastclick
#= require stores/keyword_filter
#= require stores/dynamic_heights
#= require stores/view_subcategories
#= require stores/page_state

class StoreMapPage

  pjaxContainerSelector = '.js-pjax-container-stores'
  $pjaxContainer = $(pjaxContainerSelector)

  constructor: ->
    @layoutBreakpoint = 'all and (min-width: 64em)'
    @map = new map.ResponsiveMap {
      breakpoint: @layoutBreakpoint
      palm: offset: x: 0.5, y: 0.5, zoom: 0.6
      nonPalm: offset: x: 0.75, y: 0.5, zoom: 0.7
    }

    @setupPjax()
    @setupMapToggle()
    @setupFastClick()

    # Maintain filter state when going between store list and details pages
    new StoresPageState()

    westfield.is_store_index = $('.js-stores-index').length == 1

    @dynamic_heights = new DynamicHeights(@layoutBreakpoint)
    @keyword_filter = new StoresKeywordFilter(@map, @dynamic_heights.check)

    if westfield.is_store_index
      @keyword_filter.setupKeywordFilter();

    @setupContainerHeightChecks()

    $(@pageLoaded())


  setupFastClick: =>
    $('.js-fastclick').each -> FastClick.attach(@)

  setupPjax: =>
    if $.support.pjax
      $.pjax.defaults?.timeout = 50000
      doc.on('pjax:send', @startLoading)
      doc.on('pjax:success', @stopLoading)
      doc.on('pjax:end', pjaxContainerSelector, @pjaxComplete)
      doc.on('pjax:popstate', pjaxContainerSelector, @pjaxComplete)
      doc.on('click', 'js-pjax-link-stores', @pjaxNavigate)

      body.on 'submit', 'form[data-pjax]', (event) ->
        $.pjax.submit(event, pjaxContainerSelector)

  setupMapToggle: =>
    doc.on('click', '.is-list-view .js-stores-maps-toggle-btn', @show)
    doc.on('click', '.is-map-view .js-stores-maps-toggle-btn', @hide)
    doc.on('click', '.js-pjax-view-stores', @hide)

    self = @
    doc.on 'click', '[data-store-id]', ->
      self.show()
      el = $(@)
      setTimeout ->
        self.store(el.data('store-id'))
      , 0

  setupContainerHeightChecks: =>

    # When toggling the store hours on show, recheck the container height
    doc.on 'click', '.js-store-hours-toggle-trigger', @dynamic_heights.check

    # Escape key will trigger check for store detail container height
    doc.on 'keydown', (event) =>
      if event.keyCode == 27
        @dynamic_heights.check()

  startLoading: =>
    @loading true

  stopLoading: =>
    @loading false

  loading: (state) ->
    # after pjax load has completed the user needs to see the detail
    $pjaxContainer.toggleClass('is-loading', state)

  pjaxComplete: =>
    @pageLoaded()

    westfield.is_store_index = $('.js-stores-index').length == 1
    westfield.filtering_by_category = $('.js-stores-keyword-filter-post-filter-count').length > 0

    if westfield.is_store_index
      @keyword_filter.setupKeywordFilter()
      @keyword_filter.setupToggleListPosition()

    @dynamic_heights.setupDefaultHeights()
    @dynamic_heights.check()

    $('.js-store-hours-toggle-trigger').click @dynamic_heights.check

  pageLoaded: ->
    $ ->
      if window.storeMapPageReady
        setTimeout((->
          storeMapPageReady()
          delete storeMapPageReady
        ), 0)

  pjaxNavigate: (event) =>
    @startLoading()
    $.pjax.click(event, container: $pjaxContainer)

  show: =>
    @updateGUI @map.show()
    false

  hide: =>
    @updateGUI @map.hide()

    @dynamic_heights.setupDefaultHeights()
    @dynamic_heights.check()
    @keyword_filter.setupToggleListPosition()

    false

  updateGUI: (viewingMap) ->
    $('.js-stores-maps-toggle-btn').toggleClass('is-expanded', viewingMap)
    $('.js-stores-maps-toggle-btn-txt').html(if viewingMap then 'list' else 'map')
    storesToggleWrap = $('.js-stores-maps-toggle-wrap')
    storesToggleWrap.toggleClass('is-map-view', viewingMap)
    storesToggleWrap.toggleClass('is-list-view', !viewingMap)

  store: (storeId) ->
    @map.setTarget(storeId).showLevel().zoom().highlight().pinStore(true, true).detail()

  pinFilteredStores: ->
    getId = -> $(@).data 'store-id'
    ids = $('a[data-store-id]').map getId
    @map.pinStores(ids, true)

  updatePinAndPopup: ->
    @map.pinStores([])
    @pinFilteredStores() if $('.stores-maps__filters-count').length
    @map.detail()

@storeMapPage = new StoreMapPage
