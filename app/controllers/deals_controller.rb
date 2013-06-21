class DealsController < ApplicationController

  def index
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch centre: params[:centre_id], rows: 50
    end
    @centre = CentreService.build centre
    @deals = DealService.build deal
  end

  def show
    # centre, event = nil
    # Service::API.in_parallel do
    #   centre = CentreService.fetch params[:centre_id]
    #   event = EventService.fetch params[:id]
    # end
    # @centre = CentreService.build centre
    # @event = EventService.build event
  end

end