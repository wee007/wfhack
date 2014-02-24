###
fastLiveFilter jQuery plugin 1.0.3

Copyright (c) 2011, Anthony Bush
License: <http://www.opensource.org/licenses/bsd-license.php>
Project Website: http://anthonybush.com/projects/jquery_fast_live_filter/

Modified by Alec Raeside
###

jQuery.fn.fastLiveFilter = (list, options) ->
  # Options: input, list, timeout, callback
  options = options or {}
  list = jQuery(list)
  input = this
  lastFilter = ""
  timeout = options.timeout or 0
  callback = options.callback or ->
  filterFunction = options.filterFunction or (filter, fullText) ->
    return fullText.indexOf(filter) >= 0

  keyTimeout = undefined

  filterSpeed = $("#filterspeed")

  # NOTE: because we cache lis & len here, users would need to re-init the plugin
  # if they modify the list in the DOM later.  This doesn't give us that much speed
  # boost, so perhaps it's not worth putting it here.
  lis = list.children()
  len = lis.length

  list = []
  i = 0
  lis.each (i, el)->
    el = $(el)
    if el.find(options.selector).length > 0
      list.push {
        element: el,
        text: el.find(options.selector).text(),
        hidden: false
      }
    @

  oldDisplay = (if len > 0 then lis[0].style.display else "block")

  input.change(->
    filter = input.val().toLowerCase()
    numShown = 0

    $.each list, (i, listObject)->
      if filterFunction(filter, listObject.text.toLowerCase())
        # Add class to raw DOM element for performance. See http://jsperf.com/display-none-vs-class-hidden/4
        listObject.element.get(0).className = '' if listObject.hidden
        listObject.hidden = false
        numShown++
      else
        listObject.element.get(0).className = 'hide-fully' unless listObject.hidden
        listObject.hidden = true

    callback list, numShown
    #endTime = new Date().getTime()
    #filterSpeed.html((endTime - startTime) + 'ms'  + ' (' + numShown + ' results)')
    false
  ).keydown ->
    clearTimeout keyTimeout
    keyTimeout = setTimeout(->
      return  if input.val() is lastFilter
      lastFilter = input.val()
      input.change()
      return
    , timeout)
    return

  this # maintain jQuery chainability