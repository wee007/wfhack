require 'spec_helper'
require 'vcr_helper'

describe "Movies" do
  describe "When viewing movies for bondijunction" do
    describe "When there are movies" do
      it "should display the movie titles for Bondi Junction" do
        VCR.use_cassette('bondijunction_movies') do
          get centre_movies_path(centre_id: 'bondijunction', date: '15-07-2013')
          assert_select "#movies" do
            assert_select ".title", "The Great Gatsby"
            assert_select ".title", "Man of Steel"
          end
        end
      end
    end
  end
end

describe "Movie" do
  describe "When viewing Superman movie" do
    it "display the details for that movie" do
      VCR.use_cassette('superman_movie') do
        get centre_movie_path(centre_id: 'bondijunction', id: 557, date: '16-07-2013')
        assert_select "h1", "Man of Steel"
        assert_select "p", "A young boy learns that he has extraordinary powers and is not of this Earth."
      end
    end
  end
end