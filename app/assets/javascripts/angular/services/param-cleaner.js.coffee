((app) ->
  app.service "ParamCleaner", ->
    @arrayParamR = /\[\]$/

    # This ensures that params are packaged up in the format that
    # solr/the search api expects
    @build = ( params ) ->
      cleanedParams = {}

      angular.extend cleanedParams, params

      for param of cleanedParams

        # No need to transmit empty values
        if angular.isString(cleanedParams[param]) || angular.isArray(cleanedParams[param])
          if !cleanedParams[param].length
            delete cleanedParams[param]

        # False booleans can be omitted
        if cleanedParams[param] == false
          delete cleanedParams[param]

        # Solr expects arrays to be passed as key[]=value
        if angular.isArray(cleanedParams[param]) && !param.match(@arrayParamR)
          paramName = param + '[]'
          cleanedParams[paramName] = cleanedParams[param]
          delete cleanedParams[param]

      #Do not use products as a centre.
      delete cleanedParams.centre if cleanedParams.centre == 'products'

      cleanedParams



    @deserialize = (params) ->
      for key of params
        if key.match(@arrayParamR)
          cleanKey = key.replace(@arrayParamR, "")
          params[cleanKey] = params[key]
          delete params[key]
      params

) angular.module("Westfield")