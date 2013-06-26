class DealsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch centre: params[:centre_id], rows: 50
    end
    @centre = CentreService.build centre
    @deals = DealService.build deal
  end

end