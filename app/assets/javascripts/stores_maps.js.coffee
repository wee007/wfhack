#= require jquery-pjax
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

  startLoading: =>
    @loading true

  stopLoading: =>
    @loading false

  loading: (state) ->
    # after pjax load has completed the user needs to see the detail
    @hide()

    $('.js-pjax-container-stores').toggleClass('is-loading', state)

  pjaxComplete: =>
    $ ->
      if window.storeMapPageReady
        setTimeout((->
          storeMapPageReady()
          delete storeMapPageReady
        ), 0)

  recompileAngularScope: =>
    scope = angular.element('.js-pjax-container-stores').scope();
    compile = angular.element('.js-pjax-container-stores').injector().get('$compile');

    compile($('.js-pjax-container-stores').contents())(scope);
    scope.$apply();

  pjaxNavigate: (event) =>
    @startLoading()
    $.pjax.click(event, container: $('.js-pjax-container-stores'))

  setup: =>
    body = $('body')
    if $.support.pjax
      $.pjax.defaults?.timeout = 50000
      $(document).on('pjax:send', @startLoading)
      $(document).on('pjax:success', @stopLoading)
      body.on('pjax:end', '.js-pjax-container-stores', @pjaxComplete)
      body.on('pjax:end', '.js-pjax-container-stores', @recompileAngularScope)
      body.on('click', 'a.js-pjax-link-stores', @pjaxNavigate)
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
    @pjaxComplete()

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

  pinStores: ->
    getId = -> $(@).data 'store-id'
    ids = $('a[data-store-id]').map getId
    storeMapPage.map.pinStores(ids, true, true)

$('.js-fastclick').each -> FastClick.attach(@)
@storeMapPage = new StoreMapPage
$(@storeMapPage.setup)
