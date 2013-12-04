class CampaignService
  class << self
    include ApiClientRequests

    def request_uri options = nil
      uri = URI "#{ServiceHelper.uri_for 'deal'}/campaigns.json"
      uri.query = options.to_query if options
      uri
    end

    def build json_response
      super.map { |json| Campaign.new json }
    end
  end
end
