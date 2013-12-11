describe 'Service: SuggestionsBuilder', ->

  # load the service's module
  beforeEach(module('Westfield'));

  SuggestionsBuilder = undefined

  # instantiate service
  beforeEach inject( (_SuggestionsBuilder_) ->
    SuggestionsBuilder = _SuggestionsBuilder_;
  )

  it 'should generate suggestions', ->

    searchString = "shoes"
    searchResults = {
      products: [
        {
          id: "kids-footwear",
          term: "kids shoes",
          score: 40,
          display: "Kids Shoes in Kids ",
          result_type: "category",
          attributes: {
            category_type: {
              super_cat: "shoes-footwear",
              category: "kids-footwear"
            },
            code: "kids-footwear"
          }
        }
      ],
      stores: [
        {
          id: 43076,
          term: "dc shoes",
          score: 72,
          display: "DC Shoes",
          result_type: "store",
          attributes: {
            id: 43076,
            retailer_code: "dc-shoes"
          }
        }
      ]
    }

    expect(SuggestionsBuilder.didYouMean(searchString, searchResults)).toEqual({
      products: [ { description: "Products matching 'shoes'", url: '/products?search_query=shoes' } ],
      stores: [ { description: 'DC Shoes', url: '/stores/dc-shoes/43076' } ]
    })


