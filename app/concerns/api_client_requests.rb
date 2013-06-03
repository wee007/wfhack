module ApiClientRequests
  def fetch(*args)
    Service::API.get request_uri(*args)
  end
  def build(json_response)
    json_response.respond_to?(:body) ? json_response.body : json_response
  end
  def find(*args)
    build fetch(*args)
  end
end
