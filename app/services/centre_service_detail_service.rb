class CentreServiceDetailService
  class << self
    include ApiClientRequests

    def build(json_response)
      return CentreServiceDetail.new(super(json_response)) unless super(json_response).is_a?(Array)
      super(json_response).map do |json|
        CentreServiceDetail.new(json)
      end
    end

    def request_uri(centre=nil, options={})
      if centre.nil? || centre == :all
        uri = URI("#{ServiceHelper.uri_for('centre')}/service_details.json")
      else
        uri = URI("#{ServiceHelper.uri_for('centre')}/service_details/#{centre}.json")
      end

      uri.query = options.to_query
      uri
    end
  end
end
