describe "map.micello.Link", ->

  subject = map.micello.Link

  link = 'http://www.test.com?link=1'

  it 'stores a link', ->
    expect(new subject(link).href).toEqual link

  it 'returns params', ->
    expect(new subject(link).params()).toEqual {link: '1'}

  it 'appends params', ->
    expect(new subject(link).params(foo: 'bar').href).toEqual "#{link}&foo=bar"

  it 'overwrites params', ->
    expect(new subject(link).params(link: 2).params()).toEqual {link: '2'}
