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
          id: "sass-and-bide",
          term: "sass bide",
          score: 69,
          display: "sass & bide products",
          result_type: "retail_chain",
          attributes: { retailer_code: "sass-and-bide" }
        },
        {
          id: "Reds",
          term: "reds",
          score: 10,
          display: "Red products",
          result_type: "colour",
          attributes: { colour: "Reds" }
        },
        {
          id: "toddler-baby-footwear",
          term: "babies shoes",
          score: 6,
          display: "Babies Shoes",
          result_type: "product_category",
          attributes: {
            alt_name: "Babies Shoes in Babies & Toddlers (Kids)",
            code: "toddler-baby-footwear",
            url_params: {
              sub_category: "toddler-baby-footwear",
              category: "k-babies",
              super_cat: "kids-babies"
            }
          }
        },
      ],
      stores: [
        {
          id: 43076,
          term: "dc shoes",
          score: 72,
          display: "DC Shoes",
          result_type: "store",
          attributes: { id: 43076, retailer_code: "dc-shoes" }
        }
      ]
    }

    expect(SuggestionsBuilder.didYouMean(searchString, searchResults)).toEqual({
      count : 4,
      products: [
        { description: "sass & bide products", url: '/products?retailer[]=sass-and-bide' },
        { description: "Red products", url: '/products?colour[]=Reds' },
        { description: "Products matching 'shoes'", url: '/products?search_query=shoes' }
      ],
      stores: [
        { description: 'DC Shoes', url: '/stores/dc-shoes/43076' }
      ]
    })


