class DealsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch centre: params[:centre_id], state: 'live', rows: 50
    end
    @centre = CentreService.build centre
    @deals = DealService.build deal
    meta.push title: "#{@centre.short_name} deals"
  end

  def show
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @deal = DealService.build deal

    store = StoreService.fetch @deal.deal_stores.find{|store| store.centre_id == params[:centre_id]}.store_service_id
    @store = StoreService.build store

    gon.push centre: @centre, stores: [@store]
    meta.push title: @deal.title
  end

end
