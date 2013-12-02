require 'spec_helper'

describe TileHelper do

  describe :tile_url do

    it "returns a product url" do
      product = double(:product, kind: 'product', to_param: {
        retailer_code: 'retailer_code',
        product_name: 'name',
        id: 1
      })
      expect(helper.tile_url "centre_id", product).to eq "http://test.host/centre_id/products/retailer_code/name/1"
    end

    it "returns a event url" do
      event = double(:event, kind: 'event', to_param: 'id' )
      expect(helper.tile_url "centre_id", event).to eq "http://test.host/centre_id/events/id"
    end

    it "returns a deal url" do
      deal = double(:deal, kind: 'deal', to_param: 'id', retailer_code: 'wittner')
      expect(helper.tile_url "centre_id", deal).to eq "http://test.host/centre_id/deals/wittner/id"
    end

    it "returns a canned search url" do
      cs = double(:canned_search, kind: 'canned_search', to_param: 'id', url: '/something/cool')
      helper.tile_url("centre_id", cs).should eq("http://test.host/something/cool")
    end

    it "returns the full canned search url if it's passed in full" do
      cs = double(:canned_search, kind: 'canned_search', to_param: 'id', url: 'http://example.com/something/cool')
      helper.tile_url("centre_id", cs).should eq("http://example.com/something/cool")
    end

    it "should handle error conditions by returning the url by itself" do
      cs = double(:canned_search, kind: 'canned_search', to_param: 'id', url: 'example.com/something/bad and $')
      helper.tile_url("centre_id", cs).should eq("example.com/something/bad and $")
    end

    it "returns a movie url" do
      movie = double(:movie, kind: 'movie', id: 1, title: 'movie name')
      expect(helper.tile_url "centre_id", movie).to eq "http://test.host/centre_id/movies/movie-name/1"
    end

  end

  describe :tile do
    let(:data) { {result: double(to_param: 100)} }

    it 'should render a tile' do
      helper.should_receive(:render).with partial: "/shared/tiles/product", layout: '/layouts/tile', locals: data
      helper.tile 'product', data
    end

    it 'should raise' do
      SplunkLogger::Logger.should_receive(:error)
      helper.tile 'product', data
    end
  end

end