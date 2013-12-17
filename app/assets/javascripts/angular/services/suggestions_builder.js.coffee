((app) ->
  app.service "SuggestionsBuilder", ->

    whiteListedTypes = ['store', 'retail_chain', 'colour', 'product_category']

    @didYouMean = (searchString, searchResults)->
      suggestions = {}
      suggestions.count = 0
      angular.forEach searchResults, (results, type) ->
        suggestions[type] = []
        angular.forEach results, (result) ->

          if isValidType(result.result_type) # Only add valid types
            suggestions.count++
            suggestions[type].push {
              description: result.display,
              url: buildUrl(result.result_type, result.attributes)
            }

      # Add the default product search.
      suggestions.count++
      (suggestions.products ||=[]).push dummyResult(searchString)

      suggestions

    dummyResult = (searchString)->
      "description": "Products matching '#{searchString}'",
      "url": buildUrl('product_query', query: searchString)

    buildUrl = (type, params) ->
      switch type
        when "store" then "/stores/#{params.retailer_code}/#{params.id}"
        when "retail_chain" then "/products?retailer[]=#{params.retailer_code}"
        when "product_query" then "/products?search_query=#{params.query}"
        when "colour" then "/products?colour[]=#{params.colour}"
        when "product_category" then buildProductCategoryUrl params.super_cat, params.category, params.sub_category

    buildProductCategoryUrl = (super_cat, category, sub_category) ->
      url = '/products'
      url = "#{url}/#{super_cat}" if super_cat
      url = "#{url}/#{category}" if category
      url = "#{url}?sub_category[]=#{sub_category}" if sub_category
      url

    isValidType = (toCheck) ->
      whiteListedTypes.indexOf(toCheck) >= 0

) angular.module("Westfield")
