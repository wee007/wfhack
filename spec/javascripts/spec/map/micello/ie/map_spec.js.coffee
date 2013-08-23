describe 'map.micello.ie.Map', ->

  beforeEach ->
    sinon.stub(window, '$').returns(
      on: sinon.stub()
      data: sinon.stub()
      parent: sinon.stub()
      find: sinon.stub()
      each: sinon.stub()
      width: sinon.stub()
      height: sinon.stub()
      hasClass: sinon.stub()
      addClass: sinon.stub()
      removeClass: sinon.stub()
      filter: sinon.stub()
    )
    $().parent.returns($())
    $().find.returns($())
    $().filter.returns($())
    window.westfield = centre: {micello_community: 21}, stores: []
    @subject = new map.micello.ie.Map

  afterEach ->
    $.restore()
    delete window.westfield

  describe '#attachEvents', ->

    beforeEach ->
      @subject.html.ui.zoom = on: sinon.stub()
      @subject.html.ui.levels = on: sinon.stub()
      @subject.attachEvents()

    it 'attaches the zoom in event', ->
      expect(@subject.html.ui.zoom.on).toHaveBeenCalledWith('click', '.map-micello-oldie__controls__zoom__in')

    it 'attaches the zoom out event', ->
      expect(@subject.html.ui.zoom.on).toHaveBeenCalledWith('click', '.map-micello-oldie__controls__zoom__out')

    it 'attaches the level select event', ->
      expect(@subject.html.ui.levels.on).toHaveBeenCalledWith('click')

  describe '#setSizeData', ->

    el = null
    els = null

    beforeEach ->
      @subject.html.el.width.returns(20)
      @subject.html.el.height.returns(21)
      el = data: sinon.stub(), width: sinon.stub()
      el.data.returns(el)
      $.withArgs(el).returns(el)
      els = each: sinon.stub().callsArgOn(0, el)
      @subject.setSizeData(els)

    it 'sets the container size on each map image', ->
      expect(el.data).toHaveBeenCalledWith(width: 20, height: 21)

    it 'sets the images width', ->
      expect(el.width).toHaveBeenCalled()

  describe '#zoom', ->

    el = null

    beforeEach ->
      el = data: sinon.stub().withArgs('width').returns(5), width: sinon.stub()
      $.withArgs(el).returns(el)
      @subject.html.levelImages = each: sinon.stub().callsArgOn(0, el), data: sinon.stub().returns(21)
      @subject.drag = sinon.stub()
      @subject.zoomAmount = 2
      @subject.zoom(0.5)

    it 'zooms each map image', ->
      expect(el.width).toHaveBeenCalledWith(5 * (2 + 0.5))

    it 'keeps the maps centre', ->
      expect(@subject.drag).toHaveBeenCalledWith(x: 0.5 * 21 / -2, y: 0.5 * 21 / -2)

  describe '#selectLevel', ->

    beforeEach ->
      @subject.selectLevel(2)

    it 'deactivates all level ui', ->
      expect(@subject.html.ui.levels.removeClass).toHaveBeenCalledWith('is-active')

    it 'actives a level ui', ->
      expect(@subject.html.ui.levels.addClass).toHaveBeenCalledWith('is-active')

    it 'hides all levels', ->
      expect(@subject.html.levelImages.addClass).toHaveBeenCalledWith('hide-fully')

    it 'shows a level', ->
      expect(@subject.html.levelImages.removeClass).toHaveBeenCalledWith('hide-fully')

    it 'filters the levels it shows correctly', ->
      expect(@subject.html.levelImages.filter).toHaveBeenCalledWith("[data-level=\"#{2}\"]")

  describe '#showLevel', ->

    beforeEach ->
      @subject.selectLevel = sinon.stub()
    
    it 'does nothing', ->
      @subject.showLevel()
      expect(@subject.selectLevel).not.toHaveBeenCalled()

    describe 'with target set', ->

      beforeEach ->
        @subject.target = store: level: 5

      it 'shows target stores level', ->
        @subject.showLevel()
        expect(@subject.selectLevel).toHaveBeenCalledWith(5)
