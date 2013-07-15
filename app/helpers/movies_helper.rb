module MoviesHelper

  def days(last_date, centre_code, selected_date = nil)
    today = Time.now
    last_date = Time.parse(last_date)

    days = []
    ((last_date - today)/60/60/24).ceil.times do |i|
      if i == 0
        days << link_to("Today", "/#{centre_code}/movies?date=#{Time.now.strftime('%d-%m-%Y')}", class: selected_date == Time.now.strftime('%d-%m-%Y') ? "selected" : "")
      elsif i == 1
        days << link_to("Tomorrow", "/#{centre_code}/movies?date=#{1.days.from_now.strftime('%d-%m-%Y')}", class: selected_date == 1.days.from_now.strftime('%d-%m-%Y') ? "selected" : "")
      else
        days << link_to(i.days.from_now.strftime("%A %-d"), "/#{centre_code}/movies?date=#{i.days.from_now.strftime('%d-%m-%Y')}", class: selected_date == i.days.from_now.strftime('%d-%m-%Y') ? "selected" : "")
      end
    end
    days
  end

end
