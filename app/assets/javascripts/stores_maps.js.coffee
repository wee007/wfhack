#= require jquery-pjax
#= require flexslider/jquery.flexslider
#= require map/responsive_map
#= require fastclick
#= require stores/stores_keyword_filter
#= require stores/dynamic_heights

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

  startLoading: =>
    @loading true

  stopLoading: =>
    @loading false

  loading: (state) ->
    # after pjax load has completed the user needs to see the detail
    $pjaxContainer.toggleClass('is-loading', state)

  pjaxComplete: =>
    @pageLoaded()
    @recompileAngularScope()

    westfield.is_store_index = $('.js-stores-is-index').length == 1
    westfield.filtering_by_category = $('.js-stores-keyword-filter-post-filter-count').length > 0

    if westfield.is_store_index
      @keyword_filter.setupKeywordFilter()
      @keyword_filter.setupToggleListPosition()

    @dynamic_heights.setupDefaultHeights()
    @dynamic_heights.check()

  pageLoaded: ->
    $ ->
      if window.storeMapPageReady
        setTimeout((->
          storeMapPageReady()
          delete storeMapPageReady
        ), 0)

  recompileAngularScope: ->
    scope = angular.element(pjaxContainerSelector).scope()
    compile = angular.element(pjaxContainerSelector).injector().get('$compile')

    compile($pjaxContainer.contents())(scope)
    scope.$apply()

  pjaxNavigate: (event) =>
    @startLoading()
    $.pjax.click(event, container: $pjaxContainer)

  setup: =>
    body = $('body')
    if $.support.pjax
      $.pjax.defaults?.timeout = 50000
      $(document).on('pjax:send', @startLoading)
      $(document).on('pjax:success', @stopLoading)
      body.on('pjax:end', pjaxContainerSelector, @pjaxComplete)
      body.on('pjax:popstate', pjaxContainerSelector, @pjaxComplete)
      body.on('click', 'a.js-pjax-link-stores', @pjaxNavigate)

      body.on 'submit', 'form[data-pjax]', (event) ->
        $.pjax.submit(event, pjaxContainerSelector)

    body.on('click', '.is-list-view .js-stores-maps-toggle-btn', @show)
    body.on('click', '.is-map-view .js-stores-maps-toggle-btn', @hide)

    self = @
    body.on('click', '[data-store-id]', ->
      self.show()
      el = $(@)
      setTimeout((-> self.store(el.data('store-id'))), 0)
      false
    )

    westfield.is_store_index = $('.js-stores-is-index').length == 1

    @dynamic_heights = new DynamicHeights(@layoutBreakpoint)
    @keyword_filter = new StoresKeywordFilter(@map, @dynamic_heights.check)
    if westfield.is_store_index
      @keyword_filter.setupKeywordFilter();

    $('.js-store-hours-toggle-trigger').click @dynamic_heights.check

    # Escape key will trigger check for store detail container height
    $(document).bind 'keydown', (event) =>
      if event.keyCode == 27
        @dynamic_heights.check()

    @pageLoaded()

  show: =>
    @updateGUI @map.show()
    false

  hide: =>
    @updateGUI @map.hide()
    # Remove map popup when switck back to store list

    @dynamic_heights.setupDefaultHeights()
    @dynamic_heights.check()
    @keyword_filter.setupToggleListPosition()

    false

  updateAngularStoreListControllerLinks: (viewingMap) ->
    $scope = angular.element($('[ng-controller="StoreListController"]').get(0)).scope()
    if $scope
      $scope.$apply -> $scope.viewingMap = viewingMap

  updateGUI: (viewingMap) ->
    @updateAngularStoreListControllerLinks(viewingMap)
    $('.js-stores-maps-toggle-btn').toggleClass('is-expanded', viewingMap)
    $('.js-stores-maps-toggle-btn-txt').html(if viewingMap then 'list' else 'map')
    $('.js-stores-maps-toggle-wrap').toggleClass('is-map-view', viewingMap)
    $('.js-stores-maps-toggle-wrap').toggleClass('is-list-view', !viewingMap)

    @map.forceRedraw()

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

$('.js-fastclick').each -> FastClick.attach(@)
@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
