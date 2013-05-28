class MoviesController < ApplicationController
  include Roar::Rails::ControllerAdditions

  def index
    @movies = Movie.get
  end

end