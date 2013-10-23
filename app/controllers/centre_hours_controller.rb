class CentreHoursController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre, trading_hours, stores = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      trading_hours = CentreTradingHourService.fetch params[:centre_id]
      stores = StoreService.fetch centre: params[:centre_id], per_page: "all"
    end
    @centre = CentreService.build centre
    @weeks = CentreTradingHourService.build trading_hours
    stores = StoreService.build stores

    @stores_with_hours, @store, @store_trading_hours = nil
    if stores
      @stores_with_hours = stores.select { |store| store.has_opening_hours }
      store_id = params[:store_id].present? ? params[:store_id].to_i : @stores_with_hours.first.try(:id)
      @store = StoreService.find(store_id)
      @store_trading_hours = StoreTradingHourService.find(store_id).try(:in_groups_of, 7)
    end

    @hero = Hashie::Mash.new heading: 'Shopping Hours', image: 'shopping-hours', icon: 'icon--hours'
    meta.push(
      page_title: "Shopping Hours at #{@centre.name}",
      description: "Find #{@centre.name}'s opening and trading hours for today, this week and special shopping days"
    )
  end

end