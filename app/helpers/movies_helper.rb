module MoviesHelper

  def days(last_date, centre_id, selected_date = nil, movie_id = nil)
    selected_date = Time.now.strftime("%d-%m-%Y") if selected_date.nil?

    days = []
    number_of_days_until(last_date).times do |i|
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

  def number_of_days_until(date_string)
    (Date.parse(date_string) - Date.today).ceil
  end

end
