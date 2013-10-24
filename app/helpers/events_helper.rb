module EventsHelper
  def display_event_date(event)
    content_tag(:time, :datetime => event.start_date(:raw)) do
      if event.multiple_occurrences?
        "#{event.start_date(:short_date)} - #{event.end_date(:short_date)}"
      else
        event.start_date(:full_date)
      end
    end
  end
end
