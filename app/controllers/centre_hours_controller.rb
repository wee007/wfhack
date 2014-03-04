class CentreHoursController < ApplicationController

  layout 'sub_page', only: :show

  def show
    @centre, @weeks, store_hours, all_stores = service_map \
      centre: params[:centre_id],
      centre_trading_hour: params[:centre_id],
      store_trading_hour: {centre_id: params[:centre_id]},
      store: {centre: params[:centre_id], per_page: "all"}

    @centre_trading_hour = @weeks.flatten.select{|hour| hour.date == Time.now.in_time_zone(@centre.timezone).strftime("%Y-%m-%d")}.first
    unless store_hours.empty?
      store_ids_with_hours = store_hours.map{|hour| hour[:store_id]}
      @stores_with_hours = all_stores.select{|store| store_ids_with_hours.include?(store.id.to_s)}
    end

    if @stores_with_hours.present?
      store_id = params[:store_id].present? ? params[:store_id].to_i : @stores_with_hours.first.try(:id)
      @store = StoreService.find(store_id)
      @store_trading_hours = StoreTradingHourService.find({store_id:store_id}).try(:in_groups_of, 7)
    end

    @hero = Hashie::Mash.new heading: 'Shopping Hours', image: 'shopping-hours', icon: 'icon--hours'
    meta.push(
      page_title: "Shopping Hours at #{@centre.name}",
      description: "Find #{@centre.name}'s opening and trading hours for today, this week and special shopping days"
    )
  end

end