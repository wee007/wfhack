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

  def show
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @deal = DealService.build deal

    store = StoreService.fetch @deal.deal_stores.first.id
    @store = StoreService.build store
  end

end