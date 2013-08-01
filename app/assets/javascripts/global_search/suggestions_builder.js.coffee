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
      angular.forEach ['colour','retailer','super_cat','category','sub_category','type'], (match_type)->
        angular.forEach result[match_type], (match)->
          params[match_type] ||= []
          params[match_type].push(match['value']) unless match['value'] in params[match_type]
      params

    @queryString = (result, remainder) ->
      qs=""
      angular.forEach @urlParams(result), (vs,k) ->
        angular.forEach vs, (v)->
          if qs.length == 0
            qs += "?#{k}[]=#{v}"
          else
            qs += "&#{k}[]=#{v}"
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
          result[value['data']['param_name']] ||= []
          result[value['data']['param_name']].push
            display: value['data']['display'],
            value: value['data']['param_value']
        description = ""
        if result['colour']
          description += self.to_sentence result['colour'], 'display'
        res = result['super_cat'] || []
        res = res.concat result['category'] || []
        res = res.concat result['sub_category'] || []
        res = res.concat result['type'] || []
        if res.length > 0
          if description.length > 0
            description += " "
          description += self.to_sentence res, 'display'
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
