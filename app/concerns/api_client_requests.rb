module ApiClientRequests
  def fetch(*args)
    Service::API.get request_uri(*args)
  end
  def build(json_response)
    json_response.body
  end
  def find(*args)
    build fetch(*args)
  end
end
