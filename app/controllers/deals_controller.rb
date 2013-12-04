class DealsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, deals, campaigns = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      deals = DealService.fetch centre: params[:centre_id], campaign_code: params[:campaign_code], state: 'published', rows: 50
      campaigns = CampaignService.fetch centre: params[:centre_id]
    end

    @centre = CentreService.build centre
    @deals = DealService.build deals
    @campaigns = CampaignService.build campaigns

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

    gon.push centre: @centre
    meta.push @deal.meta
    meta.push(
      title: "#{@deal.title} from #{@store.name}",
      page_title: "#{@deal.title} from #{@store.name} at #{@centre.name}",
      description: "At #{@centre.name}, find #{@deal.title} - ends #{@deal.available_to.strftime("%Y-%m-%d")}"
    )
  end

end
