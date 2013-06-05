require 'spec_helper'
require 'vcr_helper'

describe "Movies" do

  describe "When there are movies" do
    it "should display the movie titles for Bondi Junction" do
      VCR.use_cassette('bondijunction_movies') do
        get centre_movies_path(centre_id: 'bondijunction')
        assert_select "#movies" do
          assert_select ".title", "James Bond"
          assert_select ".title", "Point Break"
        end
      end
    end
  end
end
