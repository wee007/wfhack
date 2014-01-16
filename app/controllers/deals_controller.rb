class DealsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    @centre, @deals, @campaigns = service_map \
      centre: params[:centre_id],
      deal: deals_params,
      campaign: {centre: params[:centre_id]}

    eager_load_stores

    meta.push(
      page_title: "Deals, Sales & Special Offers available at #{@centre.name}",
      description: "Find the best deals, sales and great offers on a variety of products and brands at #{@centre.name}"
    )
  end

  def show
    @centre, @deal = service_map \
      centre: params[:centre_id],
      deal: params[:id]

    # Get the store, 404 if the deal is not valid in this centre.
    store_service_id = @deal.deal_stores.find{|store| store.centre_id == params[:centre_id]}.try :store_service_id
    return respond_to_error(404) unless store_service_id and @deal.available_to >= DateTime.now
    @store = StoreService.find store_service_id

    gon.push centre: @centre
    meta.push @deal.meta
    meta.push(
      title: "#{@deal.title} from #{@store.name}",
      page_title: "#{@deal.title} from #{@store.name} at #{@centre.name}",
      description: "At #{@centre.name}, find #{@deal.title} - ends #{@deal.available_to.strftime("%Y-%m-%d")}"
    )
  end

  private

  def deals_params
    deals_params = { centre: params[:centre_id], state: 'published', rows: 50 }
    deals_params.merge! campaign_code: params[:campaign_code] if params[:campaign_code]
    deals_params
  end

  def eager_load_stores
    stores = nil
    Service::API.in_parallel do
      stores = @deals.collect do |deal|
        StoreService.fetch(deal.deal_stores.first.store_service_id)
      end
    end

    stores = stores.inject({}) do |hash, store|
      store = StoreService.build store
      hash[store.id] = store
      hash
    end

    @deals.each do |deal|
      deal.store = stores[deal.deal_stores.first.store_service_id]
    end
  end

end
