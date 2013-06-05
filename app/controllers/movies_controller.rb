class MoviesController < ApplicationController

  def index
    centre, movies = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movies = MovieService.fetch centre: params[:centre_id], rows: 50
    end
    @centre = CentreService.build centre
    @movies = MovieService.build movies
  end

  def show
    centre, movies = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movie = MovieService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @movie = MovieService.build movie
  end

end
