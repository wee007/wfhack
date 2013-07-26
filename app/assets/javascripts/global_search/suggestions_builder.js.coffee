((app) ->
  app.service "SuggestionsBuilder", ->
    @to_sentence = (items, key=nil, conjunction = 'or') ->
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
      colours = []
      retailers = []
      angular.forEach result['colour'], (colour)->
        colours.push(colour['value']) unless colour['value'] in colours
      angular.forEach result['retailer'], (retailer)->
        retailers.push(retailer['value']) unless retailer['value'] in retailers
      {colour: colours, retailer: retailers}

    @queryString = (result) ->
      qs=""
      angular.forEach @urlParams(result), (vs,k) ->
        angular.forEach vs, (v)->
          if qs.length == 0
            qs += "?#{k}[]=#{v}"
          else
            qs += "&#{k}[]=#{v}"
      qs

    self = this
    @didYouMean = (searchResults)->
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
          description += " products"
        else
          description = "Products"
        if result['retailer']
          description += ' from '
          description += self.to_sentence result['retailer'], 'display'
        result['description'] = description.trim()
        result['queryString'] = self.queryString(result)
        results.push result
      results

    

) angular.module("Westfield")
