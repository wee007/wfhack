class CategoryService
  class << self
    include ApiClientRequests

    STATIC_SUPER_CATS = [
      'womens-fashion-accessories',
      'mens-fashion-accessories',
      'kids-babies',
      'shoes-footwear',
      'bags-luggage',
      'beauty-health'
    ]

    def fetch(params = {})
      @search_params = params
      get_categories
    end

    def build(json_response)
      body =  if json_response.respond_to?(:body)
                json_response.body
              else
                json_response
              end
      if body.respond_to?(:map)
        body.map do |json_object|
          Category.new(json_object)
        end
      else
        Category.new(body)
      end
    end

    private

    def get_categories
      # Get super category data from product service
      super_cats = facet_from_fetch('super_cat', ProductService.fetch(@search_params.merge({rows: 0})))

      STATIC_SUPER_CATS.map do |super_cat|
        # Get each super category
        category = super_cats['values'].find{|sc| sc.code == super_cat }
        next if category.nil?

        # Get children categories
        children = ProductService.fetch(@search_params.merge({rows: 0, super_cat: super_cat}))

        # Tack on the children of said super category
        category[:children] = facet_from_fetch('category', children)['values']

        # Implicit return
        category
      end.reject{|c| c.nil? }
    end

    def facet_from_fetch(facetName, results)
      results.facets.find{ |f| f.field == facetName }
    end
  end
end
