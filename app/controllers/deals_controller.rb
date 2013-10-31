class DealsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, deal = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deal = DealService.fetch centre: params[:centre_id], state: 'published', rows: 50
    end
    @centre = CentreService.build centre
    @deals = DealService.build deal

    meta.push(
      page_title: "Deals, Sales & Special Offers available at #{@centre.name}",
      description: "Find the best deals, sales and great offers on a variety of products and brands at #{@centre.name}"
    )
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

    gon.push centre: @centre, stores: [@store.to_gon]
    meta.push(
      page_title: "#{@deal.title} from #{@store.name} at #{@centre.name}",
      description: "At #{@centre.name}, find #{@deal.title} - ends #{@deal.available_to.strftime("%Y-%m-%d")}"
    )
  end

end
