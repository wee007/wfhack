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
      @search_params = params.dup
      # Currently this class talks to the products API rather than the
      # categories API so does not need this flag.
      @search_params.delete(:product_mapable)
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

    def category_mappings
      categories = self.find(hierarchy_level: 3)

      categories.inject({}) do |category_hash, super_category|
        category_hash[super_category.code] = "super_cat"

        super_category.children.each do |category|
          category_hash[category.code] = "category"

          category.children.each do |sub_category|
            category_hash[sub_category.code] = "sub_category"
          end
        end
        category_hash
      end
    end

    private

    def get_categories
      # Get super category data from product service
      super_cats = facet_from_fetch('super_cat', ProductService.fetch(@search_params.merge({rows: 0})))

      return [] if super_cats.blank?

      STATIC_SUPER_CATS.map do |super_cat|
        # Get each super category
        category = super_cats.find{|sc| sc.code == super_cat }
        next if category.nil?

        # Get children categories
        children = ProductService.fetch(@search_params.merge({rows: 0, super_cat: super_cat}))

        # Tack on the children of said super category
        category[:children] = facet_from_fetch('category', children)

        # Implicit return
        category
      end.reject{|c| c.nil? }
    end

    def facet_from_fetch(facetName, results)
      results.facets.find{ |f| f.field == facetName }.try '[]', 'values'
    end

  end
end
