class SearchService
  class << self
    include ApiClientRequests

    def request_uri(options)
      uri = URI("#{ServiceHelper.uri_for('search')}/search.json")
      uri.query = options.to_query
      uri
    end

  end
end