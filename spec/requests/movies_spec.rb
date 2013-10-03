require 'spec_helper'
require 'vcr_helper'

describe "Movies" do
  describe "When asking for movies for a centre with no cinema" do
    it "should return a 404" do
      VCR.use_cassette('sydney_movies') do
        get centre_movies_path(centre_id: 'sydney')
        expect(response.code).to eq "404"
      end
    end
  end

  describe "When viewing movies for bondijunction" do
    describe "When there are movies" do
      before(:each) do
        VCR.use_cassette('bondijunction_movies') do
          get centre_movies_path(centre_id: 'bondijunction')
        end
      end
      it "should display the movie titles for Bondi Junction" do
        assert_select "ul.test-movies" do
          assert_select ".test-title", "White House Down"
          assert_select ".test-title", "The Smurfs 2"
        end
      end
    end
  end
end

describe "Movie" do
  describe "When viewing a particular movie" do
    before(:each) do
      VCR.use_cassette('white_house_down_movie') do
        get centre_movie_path(centre_id: 'bondijunction', id: 182)
      end
    end
    it "display the details for that movie" do
      assert_select ".test-title", "White House Down"
    end
  end
end
