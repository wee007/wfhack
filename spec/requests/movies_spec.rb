require 'spec_helper'
require 'vcr_helper'

describe "Movies" do
  describe "When asking for movies for a centre with no cinema" do
    it "should return a 404" do
      VCR.use_cassette('sydney_movies') do
        get centre_movies_path(centre_id: 'sydney', date: '29-08-2013')
        expect(response.code).to eq "404"
      end
    end
  end

  describe "When viewing movies for bondijunction" do
    describe "When there are movies" do
      before(:each) do
        VCR.use_cassette('bondijunction_movies') do
          get centre_movies_path(centre_id: 'bondijunction', date: '27-08-2013')
        end
      end
      it "should display the movie titles for Bondi Junction" do
        assert_select "#movies" do
          assert_select ".title", "The Wolverine"
          assert_select ".title", "Elysium"
        end
      end
      it "should display store info for the cinema at bondijunction" do
        assert_select "#store_info" do
          assert_select ".phone_number", "9300 1555"
          assert_select ".email_address", 'bondi@eventscinemas.com.au'
        end
      end
    end
  end
end

describe "Movie" do
  describe "When viewing Wolverine movie" do
    before(:each) do
      VCR.use_cassette('wolverine_movie') do
        get centre_movie_path(centre_id: 'bondijunction', id: 54, date: '28-08-2013')
      end
    end
    it "display the details for that movie" do
      assert_select ".title", "The Wolverine"
    end
  end
end
