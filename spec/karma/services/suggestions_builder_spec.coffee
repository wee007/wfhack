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
    centre_id = "sydney"
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
          display: "Babies Shoes in Babies & Toddlers (Kids)",
          result_type: "product_category",
          attributes: { sub_category: "toddler-baby-footwear", category: "k-babies", super_cat: "kids-babies" }
        },
        {
          id: "toddler-baby-footwear",
          term: "babies shoes",
          score: 6,
          display: "Babies & Toddlers in Kids",
          result_type: "product_category",
          attributes: { category: "k-babies", super_cat: "kids-babies" }
        },
        {
          id: "toddler-baby-footwear",
          term: "babies shoes",
          score: 6,
          display: "Kids",
          result_type: "product_category",
          attributes: { super_cat: "kids-babies" }
        }
      ],
      stores: [
        {
          id: 43076,
          term: "shoes world",
          score: 72,
          display: "Shoes World",
          result_type: "store",
          attributes: { id: 43076, retailer_code: "dc-shoes" }
        }
      ]
    }

    expect(SuggestionsBuilder.didYouMean(searchString, searchResults, centre_id)).toEqual({
      count : 2,
      stores: [
        { description: 'Shoes World', url: '/sydney/stores/dc-shoes/43076' }
      ],
      products: [
        { description: "Products matching 'shoes'", url: '/sydney/products?search_query=shoes' }
      ]

    })


