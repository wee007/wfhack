###
fastLiveFilter jQuery plugin 1.0.3

Copyright (c) 2011, Anthony Bush
License: <http://www.opensource.org/licenses/bsd-license.php>
Project Website: http://anthonybush.com/projects/jquery_fast_live_filter/

Modified by Alec Raeside
###

#= require support/debounce

jQuery.fn.fastLiveFilter = (list, options) ->
  # Options: input, list, timeout, callback
  options = options or {}
  $list = jQuery(list)
  $listRaw = $list.get(0)
  input = this
  el = null
  oldNumShown = 0
  lastFilter = null
  timeout = options.timeout or 0
  callback = options.callback or ->
  filterFunction = options.filterFunction or (filter, fullText) ->
    return fullText.indexOf(filter) >= 0

  keyTimeout = undefined

  # NOTE: because we cache lis & len here, users would need to re-init the plugin
  # if they modify the list in the DOM later.  This doesn't give us that much speed
  # boost, so perhaps it's not worth putting it here.
  lis = $list.children()
  len = lis.length

  list = []
  for el, i in lis

    el = $(el)
    text = ''
    if el.find(options.selector).length > 0
      text = el.find(options.selector).text()
    else
      text = el.text()

    list.push {
      element: el.get(0)
      text: $.trim(text)
      hidden: false
    }
    @

  onChange = debounce( ->
    filter = input.val().toLowerCase()
    numShown = 0

    for listObject, i in list
      el = listObject.element
      if filter == '' or filterFunction(filter, listObject.text.toLowerCase())
        # Add class to raw DOM element for performance. See http://jsperf.com/display-none-vs-class-hidden/4
        el.className = el.className.replace( /(?:^|\s)hide-fully(?!\S)/g , '' ) if listObject.hidden or filter == ''
        listObject.hidden = false
      else
        el.className += ' hide-fully' unless listObject.hidden
        listObject.hidden = true

      unless listObject.hidden
        numShown++

    if numShown == 0 and oldNumShown > 0
      $listRaw.className += ' hide-fully'
    else if numShown > 0 and oldNumShown == 0
      $listRaw.className = $listRaw.className.replace( /(?:^|\s)hide-fully(?!\S)/g , '' )

    oldNumShown = numShown

    callback list, numShown
  , timeout)

  inputEvent = 'input'
  if $('html').hasClass('ie-9')
    inputEvent += ' keydown'
  input.on(inputEvent, onChange)


  this # maintain jQuery chainability