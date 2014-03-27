require 'spec_helper'


describe SearchController do
  describe "It should handle hard redirects correctly" do
    it "It should hard redirect when triggered" do
      VCR.use_cassette 'sydney_hours' do
        get :index, centre_id: 'sydney', search_query: 'hours'
        expect(response).to redirect_to('/sydney/hours')
      end
    end


    it "It shouldn't hard redirect when not triggered" do

      VCR.use_cassette 'sydney_easter' do
        get :index, centre_id: 'sydney', search_query: 'easter'
        expect(response).to_not redirect_to('/sydney/hours')
      end
    end

  end

end