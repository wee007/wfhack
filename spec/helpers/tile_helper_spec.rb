require 'spec_helper'

describe TileHelper do

  describe :tile_path do

    it "returns a product url" do
      product = double(:product, kind: 'product', retailer_code: 'retailer_code', sku: 'sku' )
      expect(helper.tile_path "centre_id", product).to eq "/centre_id/products/retailer_code/sku"
    end

    it "returns a event url" do
      event = double(:event, kind: 'event', to_param: 'id' )
      expect(helper.tile_path "centre_id", event).to eq "/centre_id/events/id"
    end

    it "returns a deal url" do
      deal = double(:deal, kind: 'deal', to_param: 'id' )
      expect(helper.tile_path "centre_id", deal).to eq "/centre_id/deals/id"
    end

  end

end