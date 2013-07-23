class EventsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, event = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      event = EventService.fetch centre: params[:centre_id], published: true, rows: 50
    end
    @centre = CentreService.build centre
    @events = EventService.build event
    @page_title = "#{@centre.name} events"
  end

  def show
    centre, event = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      event = EventService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @event = EventService.build event
    @page_title = @event.name
    @page_image = @event.image
  end

end