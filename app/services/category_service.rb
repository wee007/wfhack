class CategoryService
  class << self
    include ApiClientRequests

    # FIXME - Overriding the API fetch to return a canned response for now.
    def fetch(params = {})
      static_category_list
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

    def request_uri(options)
      WestfieldUri::Service.uri_for_api('product').tap do |uri|
        uri.path << '/categories.json'
        uri.query = options.to_query
      end
    end

    def static_category_list
      @static_category_list ||= get_static_category_list
    end

    def get_static_category_list
      # Only return these top level categories from the full list
      super_cat_order = [
        'womens-fashion-accessories',
        'mens-fashion-accessories',
        'kids-babies',
        'shoes-footwear',
        'bags-luggage',
        'beauty-health'
      ]
      cat_list = JSON.parse(
        File.read(Rails.root.join('config', 'categories.json'))
      )

      # Filter out the full category list to only contain those specified
      # above, and in the order they were specified above, i.e. the intrinsic
      # sort_order is ignored here.
      super_cat_order.map do |super_cat_code|
        cat_list.find { |c| c['code'] == super_cat_code }
      end
    end

  end
end
