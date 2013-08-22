Modernizr.load = (options) ->
  
  remaining = if options instanceof Array then options else [options]
  options = remaining.shift()

  keys = []
  keys.push('load') if options.load
  keys.push('yep') if options.test && options.yep
  keys.push('nope') if !options.test && options.nope

  for key in keys
    $script(options[key], key)

  if options.callback && keys.length
    $script.ready(keys, options.callback)

  if remaining.length
    $script.ready(keys, -> Modernizr.load(remaining))
