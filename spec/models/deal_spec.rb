require "spec_helper"

describe Deal do

  context "When asking for the retailer name and logo" do
    it "should only query the store service once" do
      mock_deal_store = double('store_service_id' => 123, "name" => "Wittner", "_links" => double({'logo' => double({'href' => "http://example.com/wittner.jpg"})}))
      StoreService.should_receive(:fetch).with(123).once.and_return("STORE_SERVICE")
      StoreService.should_receive(:build).with("STORE_SERVICE").once.and_return(mock_deal_store)

      deal = Deal.new(deal_stores:[mock_deal_store])
      deal.retailer_logo_url
      deal.store_name
    end
  end

  it "should get the store name" do
    mock_deal_store = double('store_service_id' => 123, "name" => "Wittner")
    StoreService.should_receive(:fetch).with(123).once.and_return("STORE_SERVICE")
    StoreService.should_receive(:build).with("STORE_SERVICE").once.and_return(mock_deal_store)

    deal = Deal.new(deal_stores:[mock_deal_store])
    expect(deal.store_name).to eql("Wittner")
  end

  it "should get the retailer logo url" do
    deal = Deal.new
    deal.stub(:store).and_return double(
      "has_logo?" => true,
      "logo" => "http://example.com/wittner.jpg"
    )
    expect(deal.logo).to eql("http://example.com/wittner.jpg")
  end
end
