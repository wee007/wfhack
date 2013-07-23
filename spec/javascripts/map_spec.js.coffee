describe "map.micello.Map", ->

  beforeEach ->
    window.micello = maps: jasmine.createSpyObj('map', ['init', 'MapControl'])
    micello.maps.MapControl.andReturn jasmine.createSpyObj('MapControl', ['getMapData', 'getMapCanvas', 'getMapGUI'])
    micello.maps.MapControl().getMapCanvas.andReturn jasmine.createSpyObj('MapCanvas', ['createPopup', 'setThemeFamily', 'setOverrideTheme'])
    micello.maps.MapControl().getMapGUI.andReturn {}
    micello.maps.MapControl().getMapData.andReturn jasmine.createSpyObj('MapData', ['loadCommunity'])
    @subject = new map.micello.Map

  afterEach ->
    delete micello

  describe "#constructor", ->

    it 'calls micello init', ->
      expect(micello.maps.init).toHaveBeenCalled()

    it 'creates an index', ->
      expect(@subject.index).toBeDefined()

  describe "#init", ->

    beforeEach ->
      @tempJQuery = jQuery
      jQuery = null
      @tempInit = map.micello.Map.prototype.init
      @initSpy = jasmine.createSpy('init')
      map.micello.Map.prototype.init = @initSpy
      @subject = new map.micello.Map

    afterEach ->
      delete westfield
      jQuery = @temp
      map.micello.Map.prototype.init = @tempInit

    it 'calls init once ready', ->
      window.westfield = {stores: [], centre: micello_community: 7297}
      jQuery = {}
      @subject.micelloLoaded()
      waitsFor((->
        !!@initSpy.callCount
      ), 'initMap to be called', 500)
      runs(->
        expect(@initSpy).toHaveBeenCalled()
      )

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

    options = select: 123

    beforeEach ->
      @subject.data = community: d: 0: l: []

    it 'selects a store if the option is set', ->
      @subject.highlight = jasmine.createSpy('highlight')
      @subject.options = options
      @subject.onMapChanged(comLoad: 1)
      waitsFor((->
        @subject.highlight.callCount
      ), 'highlight to be called', 500)
      runs(->
        expect(@subject.highlight).toHaveBeenCalledWith(options.select)
      )

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
