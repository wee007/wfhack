require 'spec_helper'
describe StreamService do
  it 'generates a request uri per centre' do
    expect(StreamService.request_uri('burwood').to_s).to eq 'http://customer-console.dev/api/stream/master/stream.json?centre=burwood'
  end
  describe 'all' do
    let(:mock_stream) { mock(:stream, :body => {'stream' => ['stream_item']}) }
    it 'requests the stream for the given centre' do
      Service::API.should_receive(:get)
        .with(URI('http://customer-console.dev/api/stream/master/stream.json?centre=bondijunction'))
        .and_return mock_stream
      expect(StreamService.all('bondijunction')).to eq ['stream_item']
    end
  end
end
