require 'spec_helper'
describe DealService do

  it 'generates a request uri per centre' do
    expect(DealService.request_uri(centre: 'burwood').to_s).to eq "http://deal-service.#{Rails.env}.dbg.westfield.com/api/deal/master/deals.json?centre=burwood"
  end

  context "Build" do
    describe "When we've only asked for one deal" do
      it "return deal objects" do
        mock_response = stub(:body => [{"title" => "Deal 1"},{"title" => "Deal 2"}])
        deals = DealService.build(mock_response)
        expect(deals.size).to eql(2)
        expect(deals[0].title).to eql("Deal 1")
        expect(deals[1].title).to eql("Deal 2")
      end
    end

    describe "When we've asked for many deals" do
      it "return a deal object" do
        mock_response = stub(:body => {"title" => "Deal 1"})
        deal = DealService.build(mock_response)
        expect(deal.title).to eql("Deal 1")
      end
    end
  end
end
