#= require jquery-pjax
#= require flexslider/jquery.flexslider
#= require map/responsive_map
#= require fastclick
#= require stores/stores_keyword_filter

class StoreMapPage

  pjaxContainerSelector = '.js-pjax-container-stores'
  $pjaxContainer = $(pjaxContainerSelector)

  constructor: ->
    @map = new map.ResponsiveMap {
      breakpoint: 'all and (min-width: 64em)'
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
    body.on('click', '.is-map-view .js-stores-maps-toggle-btn, .is-map-view .js-pjax-view-stores', @hide)
    # Micello hijacks clicks on the store map for touch devices
    # so listen for touchstart event which is not hijacked and send user to the url manually
    body.on 'touchstart', '.js-micello-hijack-click-fix', ->
      window.location.href = $(@).attr 'href'
    self = @
    body.on('click', '[data-store-id]', ->
      self.show()
      el = $(@)
      setTimeout((-> self.store(el.data('store-id'))), 0)
      false
    )

    @keyword_filter = new StoresKeywordFilter(@map)

    @pageLoaded()

  show: =>
    @updateGUI @map.show()
    false

  hide: =>
    @updateGUI @map.hide()
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
