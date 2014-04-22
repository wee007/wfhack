class EventsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    @events, @centre = service_map \
      event: {centre: params[:centre_id], published: true, rows: 50},
      centre: params[:centre_id]

    #Add time zone to events
    @events.each { |event| event.timezone = @centre.timezone }

    gon.push(google_content_experiment: params[:gce_var])

    meta.push(
      page_title: "Events and Activities at #{@centre.name}",
      description: "Find the latest events and activities for children and adults taking place at #{@centre.name}"
    )
  end

  def show
    @event, @centre = service_map \
      event: params[:id],
      centre: params[:centre_id]

    #Add time zone to event
    @event.timezone = @centre.timezone

    gon.push(google_content_experiment: params[:gce_var])

    meta.push @event.meta
    meta.push(
      twitter_title: "Check out this #{@event.name} at #{@centre.name}",
      page_title: "#{@event.name} at #{@centre.name}",
      description: "At #{@centre.name}, #{@event.description}"
    )
  end

end
