class MoviesController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, movies, movie_sessions, cinema = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movies = MovieService.fetch centre: params[:centre_id], date: params[:date] || Time.now.strftime("%d-%m-%Y")
      movie_sessions = MovieSessionService.fetch centre: params[:centre_id]
      cinema = StoreService.fetch_cinema_for_centre params[:centre_id]
    end
    @centre = CentreService.build centre
    @movies = MovieService.build movies
    @movie_sessions = MovieSessionService.build movie_sessions
    @cinema = StoreService.build cinema
    render_404 unless cinema
    meta.push(
      page_title: "#{@cinema.name} at #{@centre.name}",
      description: "#{@cinema.name} at #{@centre.name}"
    )
  end

  def show
    centre, movie, movie_sessions, selected_days_sessions = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movie = MovieService.fetch params[:id]
      movie_sessions = MovieSessionService.fetch movie_id: params[:id], centre: params[:centre_id]
      selected_days_sessions = MovieSessionService.fetch movie_id: params[:id], centre: params[:centre_id], date: params[:date] || Time.now.strftime("%d-%m-%Y")
    end
    @centre = CentreService.build centre
    @movie = MovieService.build movie
    @movie_sessions = MovieSessionService.build movie_sessions
    selected_days_sessions = MovieSessionService.build selected_days_sessions
    @morning_sessions = selected_days_sessions.find_all{ |session| session.morning? }
    @afternoon_sessions = selected_days_sessions.find_all{ |session| session.afternoon? }
    meta.push(
      page_title: @movie.title,
      description: @movie.title
    )
  end
end
