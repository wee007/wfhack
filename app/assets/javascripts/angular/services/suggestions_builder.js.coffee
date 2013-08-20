((app) ->
  app.service "SuggestionsBuilder", ->
    self = this
    @to_sentence = (items, key=null, conjunction = 'or') ->
      sentence = ''
      unique = []
      angular.forEach items, (item)->
        if key
          unique.push(item[key]) unless item[key] in unique
        else
          unique.push(item) unless item in unique
      angular.forEach unique, (item, ind)->
        sentence += item
        if ind < unique.length - 2
          sentence += ', '
        else if ind < unique.length - 1
          sentence += " #{conjunction} "
      sentence

    @urlParams = (result) ->
      params = {}
      angular.forEach ['colour','retailer','category'], (match_type)->
        angular.forEach result[match_type], (match)->
          angular.forEach match['attributes'], (value,key) ->
            if key in ['super_cat', 'category']
              params[key] = value
            else
              params[key] ||= []
              params[key].push(value) unless value in params[key]
      params

    @queryString = (result, remainder) ->
      qs=""
      angular.forEach @urlParams(result), (vs,k) ->
        if vs instanceof Array
          angular.forEach vs, (v)->
            if qs.length == 0
              qs += "?#{k}[]=#{v}"
            else
              qs += "&#{k}[]=#{v}"
        else
         if qs.length == 0
           qs += "?#{k}=#{vs}"
         else
           qs += "&#{k}=#{vs}"
      if remainder.length > 0
        if qs.length == 0
          qs = "?search_query=#{remainder}"
        else
          qs += "&search_query=#{remainder}"
      qs

    @remainingWords =(searchString, searchResults)->
      remainder = searchString
      angular.forEach searchResults, (searchResult)->
        angular.forEach searchResult, (value,key)->
          remainder = remainder.replace(RegExp("[^a-zA-Z]*#{key}[^a-zA-Z]*"), ' ')
      remainder.trim()

    @didYouMean = (searchString, searchResults)->
      results = []
      angular.forEach searchResults, (searchResult)->
        result = {}
        angular.forEach searchResult, (value, key)->
          result[value['data']['result_type']] ||= []
          result[value['data']['result_type']].push
            display: value['data']['display'],
            attributes: value['data']['attributes']
        description = ""
        if result['colour']
          description += self.to_sentence result['colour'], 'display'
        if result['category']
          if description.length > 0
            description += " "
          description += self.to_sentence result['category'], 'display'
        else
          if description.length > 0
            description += " products"
          else
            description += "Products"
        if result['retailer']
          description += ' from '
          description += self.to_sentence result['retailer'], 'display'
        remainder = self.remainingWords(searchString, searchResults)
        if remainder.length > 0
          description += " matching '#{remainder}'"
        result['description'] = description.trim()
        result['queryString'] = self.queryString(result, remainder)
        results.push result
      results.push self.dummyResult(searchString) unless searchString is null or searchString.length == 0
      results

    @dummyResult = (searchString)->
      "description": "Products matching '#{searchString}'",
      "queryString": "?search_query=#{searchString}"

) angular.module("Westfield")
