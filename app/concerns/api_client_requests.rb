module ApiClientRequests
  def fetch(*args)
    connection_params = connection_details if self.respond_to?(:connection_details) and  !['development','test'].include?(Rails.env)
    connection_params ||= {}
    uri = request_uri(*args)
    if (RequestStore.store[:nocache])
      if (uri.query)
        uri.query = "#{uri.query}&nocache=" + RequestStore.store[:nocache]
      else
        uri.query = "nocache=" + RequestStore.store[:nocache]
      end
    end
    begin
      ::NewRelic::Agent.increment_metric('Custom/Api/api_calls')
      #Service::API.get(uri, {}, connection_params)
    rescue Redis::BaseError => error
      # If we can't connect to redis, proceed with caching disabled
      NewRelic::Agent.notice_error(error)
      Service::API.cache_store = :null_store
      retry
    end
  end
  def build(json_response)
    json_response.respond_to?(:body) ? json_response.body : json_response
  end
  def find(*args)
    build fetch(*args)
  end
end
