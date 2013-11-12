class EventsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, event = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      event = EventService.fetch centre: params[:centre_id], published: true, rows: 50
    end

    @centre = CentreService.build centre
    @events = EventService.build event, timezone: @centre.timezone

    meta.push(
      page_title: "Events and Activities at #{@centre.name}",
      description: "Find the latest events and activities for children and adults taking place at #{@centre.name}"
    )
  end

  def show
    centre, event = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      event = EventService.fetch params[:id]
    end

    @centre = CentreService.build centre
    @event = EventService.build event, timezone: @centre.timezone

    meta.push @event.meta
    meta.push(
      twitter_title: "Check out this #{@event.name} at #{@centre.name}",
      page_title: "#{@event.name} at #{@centre.name}",
      description: "At #{@centre.name}, #{@event.description}"
    )
  end

end
