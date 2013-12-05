class MoviesController < ApplicationController

  def index
    @centre, @cinema, @movies, @movie_sessions = service_map \
      centre: params[:centre_id],
      store: cinema_id,
      movie: {centre: params[:centre_id], date: params[:date] || Time.now.strftime("%d-%m-%Y")},
      movie_session: {centre: params[:centre_id]}

    return respond_to_error(404) unless cinema_id

    meta.push(
      page_title: "#{@cinema.name} at #{@centre.short_name}",
      description: "Find the latest movies and session times at #{@cinema.name} at Westfield #{@centre.short_name}"
    )
    @hero = Hashie::Mash.new heading: @cinema.name, image: 'movies', icon: 'icon--video'
    render layout: "sub_page"
  end

  def show
    @centre, @cinema, @movie, movie_sessions = service_map \
      centre: params[:centre_id],
      store: cinema_id,
      movie: params[:id],
      movie_session: {movie_id: params[:id], centre: params[:centre_id]}

    @movies_sessions_by_date = movie_sessions.inject({}) do |acc, session|
      start_date = Date.parse(session.start_time)
      (acc[start_date] ||= []) << session
      acc
    end

    meta.push @movie.meta
    meta.push(
      page_title: "#{@movie.title} | #{@cinema.name} | #{@centre.short_name}",
      description: @movie.synopsis
    )
    render layout: "detail_view"
  end

  def cinema_id
    StoreService.cinema_id_for_centre params[:centre_id]
  end

end