module EventsHelper
  def display_event_date(event)
    content_tag(:time, :datetime => "#{event.date('%F')}T#{event.start('%H:%M')}") do
      if event.occurrences.present?
        "Multiple dates"
      else
        "#{event.date('%-d %b %Y')}, #{event.start("%I:%M %p")}"
      end
    end
  end

end
