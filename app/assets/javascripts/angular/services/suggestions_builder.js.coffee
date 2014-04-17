((app) ->
  app.service "SuggestionsBuilder", ->

    whiteListedTypes = [
      'store_category'
      'store'
      'retail_chain'
      'colour'
      'product_category'
      'event'
      'centre_information'
      'deal'
    ]

    @didYouMean = (searchString, searchResults, centre_id)->
      suggestions = {}
      suggestions.count = 0
      angular.forEach searchResults, (results, type) ->
        suggestions[type] = []
        angular.forEach results, (result) ->

          if isValidType(result.result_type)
            suggestions.count++
            suggestions[type].push {
              description: result.display,
              url: buildUrl(result.result_type, result.attributes, centre_id)
            }

      # Add the default product search.
      suggestions.count++
      (suggestions.products ||=[]).push dummyResult(searchString, centre_id)
      suggestions

    dummyResult = (searchString, centre_id)->
      if typeof westfield.google_content_experiment == 'undefined' or westfield.google_content_experiment == null
        queryType = "product"
        description = "Products matching"
      else
        queryType = "search"
        description = "Search for"

      "description": "#{description} '#{searchString}'",
      "url": buildUrl("#{queryType}_query", query: searchString, centre_id)

    buildUrl = (type, params, centre_id) ->
      switch type
        when "store" then "/#{centre_id}/stores/#{params.retailer_code}/#{params.id}"
        when "store_category" then "/#{centre_id}/stores/#{params.category}"
        when "retail_chain" then "/#{centre_id}/products?retailer[]=#{params.retailer_code}"
        when "product_query" then "/#{centre_id}/products?search_query=#{params.query}"
        when "search_query" then "/#{centre_id}/search?search_query=#{params.query}"
        when "colour" then "/#{centre_id}/products?colour[]=#{params.colour}"
        when "product_category" then buildProductCategoryUrl params.super_cat, params.category, params.sub_category, centre_id
        when "event" then "/#{centre_id}/events/#{params.id}"
        when "deal" then "/#{centre_id}/deals/#{params.retailer_code}/#{params.id}"
        when "centre_information" then "#{params.path}"

    buildProductCategoryUrl = (super_cat, category, sub_category, centre_id) ->
      url = "/#{centre_id}/products"
      url = "#{url}/#{super_cat}" if super_cat
      url = "#{url}/#{category}" if category
      url = "#{url}?sub_category[]=#{sub_category}" if sub_category
      url

    isValidType = (toCheck) ->
      whiteListedTypes.indexOf(toCheck) >= 0

) angular.module("Westfield")
