require 'spec_helper'
describe ApiClientRequests do
  describe :find do
    let(:api_client) { class FooApiClient; include ApiClientRequests; end; FooApiClient.new }
    it 'calls fetch and build' do
      api_client.should_receive :fetch
      api_client.should_receive :build
      api_client.find
    end
  end
end
