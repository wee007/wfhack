class MoviesController < ApplicationController

  def index
    @movies = Movie.get
  end

end