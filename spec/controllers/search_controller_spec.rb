require 'spec_helper'

describe SearchController do

  describe "When only one result is returned and said result is centre information" do
    it "should redirect" do
      VCR.use_cassette 'sydney_hours' do
        get :index, centre_id: 'sydney', search_query: 'hours'
        expect(response).to redirect_to('/sydney/hours')
      end
    end
  end

  describe "When multiple results are returned" do
    it "should not redirect" do
      VCR.use_cassette 'sydney_easter' do
        get :index, centre_id: 'sydney', search_query: 'easter'
        expect(response).to_not redirect_to('/sydney/hours')
      end
    end
  end

end