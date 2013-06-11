require 'spec_helper'
describe StreamService do
  it 'generates a request uri per centre' do
    expect(StreamService.request_uri(centre: 'burwood').to_s).to eq "http://stream-service.#{Rails.env}.dbg.westfield.com/api/stream/master/stream.json?centre=burwood"
  end
  it 'generates a request uri per centre filtering by products' do
    expect(StreamService.request_uri(centre: 'burwood', stream: 'product').to_s).to eq "http://stream-service.#{Rails.env}.dbg.westfield.com/api/stream/master/product_stream.json?centre=burwood"
  end
end
