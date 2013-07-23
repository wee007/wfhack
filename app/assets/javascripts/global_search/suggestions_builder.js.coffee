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
        if result['retailer']
          description += ' from '
          description += self.to_sentence result['retailer'], 'display'
        result['description'] = description.trim()
        results.push result
      results

    

) angular.module("Westfield")
