class ProductService

  class << self
    include ApiClientRequests
    def build(json)
      results = json.respond_to?(:body) ? json.body : json
      if results.kind_of?(Array)
        results.collect { |result| Product.new result }
      elsif results.has_key? :facets
        products = results.delete(:results).collect { |result| Product.new result }
        ProductSearch.new results.merge products: products
      else
        Product.new results
      end
    end

  private

    def request_uri(options)

      return show_uri(options) unless options.is_a?(Hash)

      options.delete :controller
      action = options.delete :action
      options.reject! {|k,v|v.blank? || v.is_a?(Array) && v.all?(&:blank?) }
      if action == 'lite'
        lite_uri(options)
      elsif options[:category_codes].present?
        uri = URI("#{ServiceHelper.uri_for('product')}/categories.json")
        uri.query = options.to_query
        uri
      else
        search_uri(options)
      end
    end

    def show_uri(id)
      URI("#{ServiceHelper.uri_for('product')}/products/#{id}.json")
    end

    def lite_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      centre = search_opts.delete :centre_id
      search_opts[:centre] ||= centre
      uri = URI("#{ServiceHelper.uri_for('product')}/products.json")
      uri.query = search_opts.to_query
      uri
    end

    def search_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      centre = search_opts.delete :centre_id
      search_opts[:centre] ||= centre
      uri = URI("#{ServiceHelper.uri_for('product')}/products/search.json")
      uri.query = search_opts.to_query
      uri
    end
  end
end
