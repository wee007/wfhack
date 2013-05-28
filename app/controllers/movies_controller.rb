class MoviesController < ApplicationController
  include Roar::Rails::ControllerAdditions

  def index
    @movies = Movies.get("http://localhost:3001/api/movie/master/movies.json?centre=bondijunction", 'application/json').movies
  end

end