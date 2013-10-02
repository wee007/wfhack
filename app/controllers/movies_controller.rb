class MoviesController < ApplicationController

  def index
    centre, movies, movie_sessions, cinema = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      movies = MovieService.fetch centre: params[:centre_id], date: params[:date] || Time.now.strftime("%d-%m-%Y")
      movie_sessions = MovieSessionService.fetch centre: params[:centre_id]
      cinema = StoreService.fetch_cinema_for_centre params[:centre_id]
    end
    @centre = CentreService.build centre
    @movie_sessions = MovieSessionService.build movie_sessions
    @movies = MovieService.build movies
    @cinema = StoreService.build cinema

    unless cinema
      render_404; return
    end

    meta.push(
      page_title: "#{@cinema.name} at #{@centre.short_name}",
      description: "#{@cinema.name} at #{@centre.short_name}"
    )
    @hero = Hashie::Mash.new heading: @cinema.name, image: 'movies', icon: 'icon--video'
    render layout: "sub_page"
  end

  def show
    centre, movie, movie_sessions, selected_days_sessions, cinema = nil
    Service::API.in_parallel do
      cinema = StoreService.fetch_cinema_for_centre params[:centre_id]
      centre = CentreService.fetch params[:centre_id]
      movie = MovieService.fetch params[:id]
      movie_sessions = MovieSessionService.fetch movie_id: params[:id], centre: params[:centre_id]
    end
    @cinema = StoreService.build cinema
    @centre = CentreService.build centre
    @movie = MovieService.build movie
    movie_sessions = MovieSessionService.build movie_sessions
    @movies_sessions_by_date = movie_sessions.inject({}) do |acc, session|
      start_date = Date.parse(session.start_time)
      acc[start_date] = [] unless acc.has_key? start_date
      acc[start_date] << session
      acc
    end

    meta.push(
      page_title: @movie.title,
      description: @movie.title
    )
    render layout: "detail_view"
  end
end
