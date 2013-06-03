require 'spec_helper'
describe StreamService do
  it 'generates a request uri per centre' do
    expect(StreamService.request_uri('burwood').to_s).to eq 'http://customer-console.dev/api/stream/master/stream.json?centre=burwood'
  end
end
