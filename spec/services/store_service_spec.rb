require 'spec_helper'
describe StoreService do
  describe "When getting a cinema for a specific centre" do
    before(:each) do
      cinema = nil
      VCR.use_cassette('bondi_cinema') do
        cinema = StoreService.fetch_cinema_for_centre 'bondijunction'
      end
      @cinema = StoreService.build cinema
    end
    it "should return the store" do
      expect(@cinema.url).to eql("http://www.eventcinemas.com.au")
    end
  end

  describe "When asking for a cinema from a centre that doesn't have one" do
    before(:each) do
      cinema = nil
      VCR.use_cassette('sydney_cinema') do
        cinema = StoreService.fetch_cinema_for_centre 'sydney'
      end
      @cinema = StoreService.build cinema
    end
    it "should return an empty store" do
      expect(@cinema).to be_empty
    end
  end
end
