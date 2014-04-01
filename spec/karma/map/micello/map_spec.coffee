describe "map.micello.Map", ->

  beforeEach ->
    sinon.stub(window, '$').returns({
      text: sinon.stub()
      on: sinon.stub()
      css: sinon.stub()
      remove: sinon.stub()
      first: sinon.stub().returns({
        on: sinon.stub()
      })
    })
    $.ajax = sinon.stub().returns(success: sinon.stub())
    $.getJSON = sinon.stub().callsArgWith(1, [])
    window.westfield = {centre: {micello_community: 7297}}
    window.micello = {
      maps: {
        init: sinon.stub().callsArg(1)
        MapView: prototype: translate: $.noop
        MapGUI: prototype: createMouseShield: $.noop
        MapControl: sinon.stub().returns({
          getMapData: sinon.stub().returns({
            loadCommunity: sinon.stub()
            removeInlay: sinon.stub()
            removeMarkerOverlay: sinon.stub()
            getCurrentLevel: sinon.stub()
            getGeometryLevel: sinon.stub()
            setLevel: sinon.stub()
            addInlay: sinon.stub()
          })
          getMapCanvas: sinon.stub().returns({
            createPopup: sinon.stub()
            setThemeFamily: sinon.stub()
            setOverrideTheme: sinon.stub()
          })
          getMapView: sinon.stub().returns({
            getViewportWidth: sinon.stub()
            getViewportHeight: sinon.stub()
          })
          getMapGUI: sinon.stub().returns({
            createMouseShield: sinon.stub()
          })
          showInfoWindow: sinon.stub()
          hideInfoWindow: sinon.stub()
        })
      }
    }
    @subject = new map.micello.Map(deferred: $.Deferred())

  afterEach ->
    delete micello
    delete westfield
    $.restore()

  describe "#constructor", ->

    it 'inits the micello map', ->
      expect(micello.maps.init).toHaveBeenCalled()

  describe "#applyCustomTheme", ->

    beforeEach ->
      @gui = {}
      @canvas = micello.maps.MapControl().getMapCanvas()

    it 'applies theme overrides', ->
      @subject.applyCustomTheme(@gui, @canvas)
      expect(@canvas.setOverrideTheme).toHaveBeenCalledWith(map.micello.customTheme.theme)

    it 'sets the theme family', ->
      @subject.applyCustomTheme(@gui, @canvas)
      expect(@canvas.setThemeFamily).toHaveBeenCalledWith(map.micello.customTheme.themeFamily)

  describe "#onMapChanged", ->

    beforeEach ->
      @subject.data = community: d: 0: l: []
      @subject.processGeoms = sinon.stub()
      @subject.applyWestfieldStoreNames = sinon.stub()
      @subject.applyCustomIcons = sinon.stub()

    it 'process geoms', ->
      @subject.onMapChanged(comLoad: 1)
      expect(@subject.processGeoms).toHaveBeenCalled()

  describe "#highlight", ->

    beforeEach ->
      @storeId = 21
      @subject.stores = [
        id: @storeId,
        micello_geom_id: 712,
        today_closing_time: '18:30',
        _links: {
          logo: {
            href: '/path/to/store/logo'
          }
        }
      ]

      @subject.store_trading_hours = {}
      @subject.store_trading_hours[@storeId] = {
        centre_id: "bondijunction",
        closed: false,
        closing_time: "17:00",
        date: "2014-03-05",
        day_of_week: 2,
        description: null,
        hour_type: "standard",
        id: 23670,
        opening_time: "09:00",
        store_id: @storeId
      }
      @subject.processGeoms([
        id: 712
      ])
      @subject.processStores()

    it 'does nothing', ->
      @subject.highlight()
      expect(@subject.data.addInlay).not.toHaveBeenCalled()

    describe 'with target', ->

      beforeEach ->
        @subject.setTarget(@storeId)

      it 'adds an inlay', ->
        @subject.highlight()
        expect(@subject.data.addInlay).toHaveBeenCalled()
