class map.micello.Link

  regex: /(.*?)\?([^#]+)(.*)/

  constructor: (@href) ->

  parseParams: ->
    paramsObj = {}
    params = (@href.replace(@regex, '$2') || '').split('&')
    for param in params
      param = param.split('=')
      paramsObj[param[0]] = param[1]
    paramsObj

  setParams: (newParams) ->
    params = @parseParams()
    for name, value of newParams
      params[name] = value
    paramsArr = []
    for name, value of params
      paramsArr.push "#{name}=#{value}"
    @href = @href.replace(@regex, "$1?#{paramsArr.join('&')}$3")
    @

  params: (params) ->
    if !params
      return @parseParams()
    else
      @setParams(params)
    @
