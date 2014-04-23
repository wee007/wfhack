module ApiClientRequests
  def fetch(*args)
    connection_params = connection_details if self.respond_to?(:connection_details) and  !['development','test'].include?(Rails.env)
    connection_params ||= {}
    if (RequestStore.store[:nocache])
      connection_params[:connection] ||= {}
      connection_params[:connection][:nocache] = true
    end
    Service::API.get(request_uri(*args), {}, connection_params)
  end
  def build(json_response)
    json_response.respond_to?(:body) ? json_response.body : json_response
  end
  def find(*args)
    build fetch(*args)
  end
end
