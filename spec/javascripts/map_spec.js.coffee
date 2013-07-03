describe "Map", ->

  beforeEach ->
    window.micello = maps: jasmine.createSpyObj('map', ['init'])
    @subject = new Map

  afterEach ->
    delete micello

  describe "#constructor", ->

    it 'calls micello init', ->
      expect(micello.maps.init).toHaveBeenCalled()

    it 'creates an index', ->
      expect(@subject.index).toBeDefined()

  describe "#init", ->

    beforeEach ->
      @temp = jQuery
      jQuery = null
      @subject.initMap = jasmine.createSpy('initMap')
      @subject.attachClickHandler = jasmine.createSpy('attachClickHandler')
      @subject.init()

    afterEach ->
      delete westfield
      jQuery = @temp

    it 'calls initMap once the westfield object is defined', ->
      window.westfield = {}
      waitsFor((->
        !!@subject.initMap.callCount
      ), 'initMap to be called', 500)
      runs(->
        expect(@subject.initMap).toHaveBeenCalled()
      )

    it 'calls attachClickHandler', ->
      jQuery = {}
      waitsFor((->
        !!@subject.attachClickHandler.callCount
      ), 'attachClickHandler to be called', 500)
      runs(->
        expect(@subject.attachClickHandler).toHaveBeenCalled()
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
