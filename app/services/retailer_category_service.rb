class RetailerCategoryService
  class << self
    include ApiClientRequests

    def request_uri(options = nil)
      uri = URI("#{ServiceHelper.uri_for('category')}/categories.json")
      uri.query = options.to_query if options

      uri
    end

    def connection_details
      {connection: {proxy: 'http://proxy.dbg.westfield.com:8080'}}
    end
  end
end