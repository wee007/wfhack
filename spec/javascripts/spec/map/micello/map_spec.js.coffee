describe "map.micello.Map", ->

  beforeEach ->
    sinon.stub(window, '$').returns({
      text: sinon.stub()
      on: sinon.stub()
    })
    $.ajax = sinon.stub().returns(success: sinon.stub())
    window.westfield = {stores: [], centre: micello_community: 7297}
    window.micello = {
      maps: {
        init: sinon.stub().callsArg(1)
        MapControl: sinon.stub().returns({
          getMapData: sinon.stub().returns({
            loadCommunity: sinon.stub()
            removeInlay: sinon.stub()
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
          getMapGUI: sinon.stub().returns({})
          showInfoWindow: sinon.stub()
          hideInfoWindow: sinon.stub()
        })
      }
    }
    @subject = new map.micello.Map

  afterEach ->
    delete micello
    delete westfield
    $.restore()

  describe "#constructor", ->

    it 'loads addresses', ->
      expect($.ajax).toHaveBeenCalled()

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
      @subject.ready = sinon.stub()
      @subject.applyCustomIcons = sinon.stub()

    it 'calls ready', ->
      @subject.onMapChanged(comLoad: 1)
      expect(@subject.ready).toHaveBeenCalled()

  describe "#highlight", ->

    beforeEach ->
      @storeId = 21
      @indexObj = {id: 21, gid: 24, store: {}}
      @subject.index.findById = sinon.stub().returns().withArgs(21).returns(@indexObj)
      @subject.data.getCurrentLevel.returns(cid: 123)
      @subject.data.getGeometryLevel.returns(id: 123)

    it 'does nothing', ->
      @subject.highlight()
      expect(@subject.data.addInlay).not.toHaveBeenCalled()

    describe 'with target', ->

      beforeEach ->
        @subject.setTarget(@storeId)

      it 'adds an inlay', ->
        @subject.highlight()
        expect(@subject.data.addInlay).toHaveBeenCalled()
