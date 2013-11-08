require 'spec_helper'
describe StreamService do

  let(:stream_json) { JSON.parse File.read("spec/fixtures/stream.json") }
  let(:unidentified_stream_json) { JSON.parse File.read("spec/fixtures/stream-with-unidentified-results.json") }
  let(:built) { StreamService.build(stream_json) }

  it 'generates a request uri per centre' do
    expect(StreamService.request_uri(centre: 'burwood').to_s).to eq "http://stream-service.#{Rails.env}.dbg.westfield.com/api/stream/master/stream.json?centre=burwood"
  end

  it 'generates a request uri per centre filtering by products' do
    expect(StreamService.request_uri(centre: 'burwood', stream: 'product').to_s).to eq "http://stream-service.#{Rails.env}.dbg.westfield.com/api/stream/master/product_stream.json?centre=burwood"
  end

  it "shouldn't error on an example feed" do
    expect { built }.to_not raise_error
  end

  it "should be able to load an example feed" do
    built.length.should == 4
  end

  it "should exclude unrecognised tiles" do
    b = StreamService.build(unidentified_stream_json)
    b.length.should == 1
  end

  it "should be able to load a product" do
    built.select{|p| p.is_a?(Product) }.length.should == 1
  end

  it "should be able to load an event" do
    built.select{|e| e.is_a?(Event) }.length.should == 1
  end

  it "should be able to load a deal" do
    built.select{|d| d.is_a?(Deal) }.length.should == 1
  end

  it "should be able to load a canned search" do
    built.select{|c| c.is_a?(CannedSearch) }.length.should == 1
  end

end
