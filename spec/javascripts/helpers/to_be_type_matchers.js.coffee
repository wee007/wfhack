toBeType = (preset) ->
  (expected = preset) ->
    actual = typeof @actual
    notText = if @isNot then " not" else ""
    @message = ->
      "Expected #{actual}#{notText} to be #{expected}"
    expected == actual

beforeEach ->
  @addMatchers
    toBeType: toBeType()
    toBeFunction: toBeType('function')
