module ApiClientRequests
  def fetch(*args)
    connection_params = connection_details if self.respond_to?(:connection_details) and Rails.env != 'development'
    Service::API.get(request_uri(*args), {}, connection_params || {})
  end
  def build(json_response)
    json_response.respond_to?(:body) ? json_response.body : json_response
  end
  def find(*args)
    build fetch(*args)
  end
end
