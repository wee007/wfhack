module MoviesHelper

  def days(last_date, centre_id, selected_date = nil, movie_id = nil)
    selected_date = Time.now.strftime("%d-%m-%Y") if selected_date.nil?
    today = Time.now
    last_date = Time.parse(last_date)

    days = []
    ((last_date - today)/60/60/24).ceil.times do |i|
      text = i.days.from_now.localtime.strftime("%a %-d %b")
      text = "Today" if i == 0
      text = "Tomorrow" if i == 1

      i_day = i.days.from_now.localtime.strftime('%d-%m-%Y')
      if movie_id
        days << link_to(text, centre_movie_path(centre_id, movie_id, date: i_day), class: selected_date == i_day ? "selected" : "")
      else
        days << link_to(text, centre_movies_path(centre_id, date: i_day), class: selected_date == i_day ? "is-active" : "")
      end
    end
    days
  end

end
