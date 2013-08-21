describe "map.micello.Map", ->

  beforeEach ->
    @jquery = window.$
    jquery = jasmine.createSpyObj('jQeury', ['html'])
    window.$ = jasmine.createSpy().andReturn(jquery)
    window.$.ajax = jasmine.createSpy().andReturn(jasmine.createSpyObj('ajax', ['success']))
    window.westfield = {stores: [], centre: micello_community: 7297}
    window.micello = maps: jasmine.createSpyObj('map', ['init', 'MapControl'])
    micello.maps.MapControl.andReturn jasmine.createSpyObj('MapControl', ['getMapData', 'getMapCanvas', 'getMapGUI'])
    micello.maps.MapControl().getMapCanvas.andReturn jasmine.createSpyObj('MapCanvas', ['createPopup', 'setThemeFamily', 'setOverrideTheme'])
    micello.maps.MapControl().getMapGUI.andReturn {}
    micello.maps.MapControl().getMapData.andReturn jasmine.createSpyObj('MapData', ['loadCommunity'])
    @subject = new map.micello.Map

  afterEach ->
    delete micello
    delete westfield
    window.$ = @jquery

  describe "#constructor", ->

    it 'loads addresses', ->
      expect($.ajax).toHaveBeenCalled()

    it 'inits the micello map', ->
      expect(micello.maps.init).toHaveBeenCalled()

  describe "#applyCustomTheme", ->

    beforeEach ->
      @gui = {}
      @canvas = jasmine.createSpyObj('canvas', ['setThemeFamily', 'setOverrideTheme'])

    it 'applies theme overrides', ->
      @subject.applyCustomTheme(@gui, @canvas)
      expect(@canvas.setOverrideTheme).toHaveBeenCalledWith(@subject.customTheme)

    it 'sets the theme family', ->
      @subject.applyCustomTheme(@gui, @canvas)
      expect(@canvas.setThemeFamily).toHaveBeenCalledWith('Standard')

  describe "#onMapChanged", ->

    beforeEach ->
      @subject.data = community: d: 0: l: []
      @subject.ready = jasmine.createSpy()

    it 'calls ready', ->
      @subject.onMapChanged(comLoad: 1)
      expect(@subject.ready).toHaveBeenCalled()

  describe "#highlight", ->

    beforeEach ->
      @storeId = 21
      @indexObj = {id: 21, gid: 24, store: {}}
      @subject.index.findById = jasmine.createSpy('findById').andReturn(@indexObj)
      @subject.data = jasmine.createSpyObj('data', ['removeInlay', 'getCurrentLevel', 'getGeometryLevel', 'setLevel', 'addInlay'])
      @subject.control = jasmine.createSpyObj('control', ['showInfoWindow'])
      @subject.data.getCurrentLevel.andReturn(cid: 123)
      @subject.data.getGeometryLevel.andReturn(id: 123)

    it 'returns an index object', ->
      expect(@subject.highlight(@storeId)).toEqual(@indexObj)
