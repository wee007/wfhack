# From underscore.js
# Return a function which will not execute until not called for an arbitrary amount of time

@debounce = (func, wait, immediate) ->
  timeout = undefined
  args = undefined
  context = undefined
  timestamp = undefined
  result = undefined
  later = ->
    last = new Date().getTime() - timestamp
    if last < wait
      timeout = setTimeout(later, wait - last)
    else
      timeout = null
      unless immediate
        result = func.apply(context, args)
        context = args = null
    return

  ->
    context = this
    args = arguments
    timestamp = new Date().getTime()
    callNow = immediate and not timeout
    timeout = setTimeout(later, wait)  unless timeout
    if callNow
      result = func.apply(context, args)
      context = args = null
    result