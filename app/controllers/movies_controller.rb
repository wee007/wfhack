class MoviesController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, movies, movie_sessions = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movies = MovieService.fetch centre: params[:centre_id], date: params[:date] || Time.now.strftime("%d-%m-%Y")
      movie_sessions = MovieSessionService.fetch centre: params[:centre_id]
    end
    @centre = CentreService.build centre
    @movies = MovieService.build movies
    @movie_sessions = MovieSessionService.build movie_sessions
  end
end
