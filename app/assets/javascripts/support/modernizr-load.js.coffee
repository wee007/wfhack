makeArray = (obj) ->
  obj = [obj] unless obj instanceof Array
  obj

Modernizr.load = (options) ->
  
  remaining = makeArray(options)
  options = remaining.shift()

  scripts = []
  keys = []
  keys.push('load') if options.load
  keys.push('yep') if options.test && options.yep
  keys.push('nope') if !options.test && options.nope

  for key in keys
    scripts = scripts.concat makeArray(options[key])

  for script in scripts
    $script(script, script)

  if options.callback && scripts.length
    $script.ready(scripts, options.callback)

  if remaining.length
    $script.ready(scripts, -> Modernizr.load(remaining))
