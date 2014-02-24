module EventsHelper
  def display_event_date(event)
    if event.multiple_occurrences?
      if event.multiple_occurrences_on_same_day?
        content_tag(:time, datetime: event.start_date(:raw), itemprop: 'startDate') do
          event.start_date(:short_date_with_year)
        end
      else
        content_tag(:time, event.start_date(:short_date), datetime: event.start_date(:raw), itemprop: 'startDate') + " &#8211; ".html_safe + content_tag(:time, event.end_date(:short_date), datetime: event.end_date(:raw), itemprop: 'endDate')
      end
    else
      content_tag(:time, datetime: event.start_date(:raw), itemprop: 'startDate') do
        event.start_date(:full_date)
      end
    end
  end
end