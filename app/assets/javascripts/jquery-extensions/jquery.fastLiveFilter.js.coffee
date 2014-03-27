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
  $list = jQuery(list)
  input = this
  el = null
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
      el = listObject.element.get(0)
      if filter == '' or filterFunction(filter, listObject.text.toLowerCase())
        # Add class to raw DOM element for performance. See http://jsperf.com/display-none-vs-class-hidden/4
        el.className = el.className.replace( /(?:^|\s)hide-fully(?!\S)/g , '' ) if listObject.hidden or filter == ''
        listObject.hidden = false
        numShown++
      else
        el.className += ' hide-fully' unless listObject.hidden
        listObject.hidden = true

      if numShown == 0
        $list.addClass 'hide-fully'
      else
        $list.removeClass 'hide-fully'

    callback list, numShown

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