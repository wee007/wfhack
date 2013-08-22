describe 'map.Micello', ->

  beforeEach ->
    @subject = new map.Micello

  afterEach ->
    map.Micello.loadTriggered = false

  describe '#micelloSupported', ->

    beforeEach ->
      el = hasClass: sinon.stub().returns(false)
      @subject.mapContainer = sinon.stub().returns(el)

    it 'is supported', ->
      expect(@subject.micelloSupported()).toBe(true)

    describe 'without support', ->

      beforeEach ->
        @subject.mapContainer().hasClass.withArgs(@subject.noSupportClass).returns(true)

      it 'is not supported', ->
        expect(@subject.micelloSupported()).toBe(false)

  describe '#load', ->

    beforeEach ->
      sinon.stub(Modernizr, 'load')
      sinon.stub(map.micello, 'Map')

    afterEach ->
      Modernizr.load.restore()
      map.micello.Map.restore()

    it 'calls Modernizr.load', ->
      @subject.load()
      expect(Modernizr.load).toHaveBeenCalled()

    describe 'once called', ->

      beforeEach ->
        @subject.load()

      it 'does not call Modernizr.load again', ->
        @subject.load()
        expect(Modernizr.load).toHaveBeenCalledOnce()

  describe '#initilizeMap', ->

    beforeEach ->
      sinon.stub(map.micello, 'Map')

    afterEach ->
      map.micello.Map.restore()

    it 'creates a new map', ->
      @subject.initializeMap()
      expect(map.micello.Map).toHaveBeenCalled()

    describe 'once called', ->

      beforeEach ->
        @subject.initializeMap()

      it 'does not create another map', ->
        @subject.initializeMap()
        expect(map.micello.Map).toHaveBeenCalledOnce()

    describe 'when map scripts have not been loaded', ->

      beforeEach ->
        sinon.stub(window, 'setTimeout')
        @tmp = map.micello
        map.micello = undefined

      afterEach ->
        setTimeout.restore()
        map.micello = @tmp

      it 'queues the intialization to be re-run', ->
        @subject.initializeMap()
        expect(setTimeout).toHaveBeenCalledWith(@subject.initializeMap)

  describe 'proxied method', ->

    proxiedMethods = ['setTarget', 'showLevel', 'zoom', 'detail', 'highlight', 'centre', 'centreOffset', 'reset']

    for method in proxiedMethods
      do (method) ->

        describe "##{method}", ->

          beforeEach ->
            map = {}
            map[method] = sinon.stub()
            @subject.map = map

          it 'calls through to the map', ->
            @subject.deferred.resolveWith(@subject.map)
            @subject[method]()
            expect(@subject.map[method]).toHaveBeenCalled()

          it 'is called on the map once it is ready', ->
            @subject[method]()
            @subject.deferred.resolveWith(@subject.map)
            expect(@subject.map[method]).toHaveBeenCalled()
