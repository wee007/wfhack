class StoreService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{AppConfig.store_service_url}/stores/#{options}.json")
      elsif options.present?
        uri = URI("#{AppConfig.store_service_url}/stores.json")
        uri.query = options.to_query
        uri
      else
        URI("#{AppConfig.store_service_url}/stores.json")
      end

    end
  end
end
