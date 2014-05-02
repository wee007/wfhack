module ApiClientRequests
  def fetch(*args)
    connection_params = connection_details if self.respond_to?(:connection_details) and  !['development','test'].include?(Rails.env)
    connection_params ||= {}
    begin
      Service::API.get(request_uri(*args), {}, connection_params)
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
