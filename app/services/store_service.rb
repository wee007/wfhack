class StoreService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("http://store-service.#{AppConfig.service_host}/stores/#{options}.json")
      elsif options.present?
        uri = URI("http://store-service.#{AppConfig.service_host}/stores.json")
        uri.query = options.to_query
        uri
      else
        URI("http://store-service.#{AppConfig.service_host}/stores.json")
      end

    end
  end
end
