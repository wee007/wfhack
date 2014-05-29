class RetailerCategoryService
  class << self
    include ApiClientRequests

    def request_uri(options = nil)
      uri = URI("#{ServiceHelper.uri_for('category',  protocol = 'https', host: :external)}/categories.json")
      uri.query = options.to_query if options

      uri
    end

    def connection_details
      {connection: {}}
    end
  end
end
