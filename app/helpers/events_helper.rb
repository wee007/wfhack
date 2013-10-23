module EventsHelper
  def display_event_date(event)
    content_tag(:time, :datetime => event.date(:raw)) do
      if event.occurrences.length > 1
        "#{event.date(:short_date)} - #{event.end_date(:short_date)}"
      else
        event.date(:full_date)
      end
    end
  end
end
