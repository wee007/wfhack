require 'spec_helper'

describe "Movies" do
  
  describe "When there are movies" do
    before(:each) do
      #ensure the fixture file is there.
      
      movies_response = {
        movies: [
          {title: "James Bond"},
          {title: "Point Break"}
        ]
      }
      FakeWeb.register_uri(:get, "http://localhost:3001/api/movie/master/movies.json?centre=bondijunction", :body => movies_response.to_json)
    end
    after(:each) do
      FakeWeb.clean_registry
    end
    it "should display the movie titles for Bondi Junction" do
      get movies_path(centre: 'bondijunction')
      
      assert_select "#movies" do
        assert_select ".title", "James Bond"
        assert_select ".title", "Point Break"
      end
    end
  end
end
