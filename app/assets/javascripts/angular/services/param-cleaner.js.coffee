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
        else if cleanedParams[param] == true
          # Make it a string, so it is parsed correctly by the router
          cleanedParams[param] = "true"

        # Solr expects arrays to be passed as key[]=value
        if angular.isArray(cleanedParams[param]) && !param.match(@arrayParamR)
          paramName = param + '[]'
          cleanedParams[paramName] = cleanedParams[param]
          delete cleanedParams[param]

      cleanedParams



    @deserialize = (params) ->
      for key of params
        if key.match(@arrayParamR)
          cleanKey = key.replace(@arrayParamR, "")
          params[cleanKey] = params[key]
          delete params[key]
      params

) angular.module("Westfield")