class EventsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    @events, @centre = in_parallel \
      event: {centre: params[:centre_id], published: true, rows: 50},
      centre: params[:centre_id]

    #Add time zone to events
    @events.each { |event| event.timezone = @centre.timezone }

    meta.push(
      page_title: "Events and Activities at #{@centre.name}",
      description: "Find the latest events and activities for children and adults taking place at #{@centre.name}"
    )
  end

  def show
    @event, @centre = in_parallel \
      event: params[:id],
      centre: params[:centre_id]

    #Add time zone to event
    @event.timezone = @centre.timezone

    meta.push @event.meta
    meta.push(
      twitter_title: "Check out this #{@event.name} at #{@centre.name}",
      page_title: "#{@event.name} at #{@centre.name}",
      description: "At #{@centre.name}, #{@event.description}"
    )
  end

end
