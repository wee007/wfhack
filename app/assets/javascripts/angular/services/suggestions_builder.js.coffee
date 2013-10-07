((app) ->
  app.service "SuggestionsBuilder", ->

    @didYouMean = (searchString, searchResults)->
      suggestions = {}
      angular.forEach searchResults, (results, type) ->
        suggestions[type] = []
        angular.forEach results, (result) ->

          # Skip category for now till we can sort it out.
          next if result.result_type == 'category'

          suggestions[type].push {
            description: result.display,
            url: buildUrl(result.result_type, result.attributes)
          }

      # Add the default product search.
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
        when "category" then "/products?#{params.category_type}=#{params.code}"


) angular.module("Westfield")
