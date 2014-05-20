class CentreHoursController < ApplicationController

  layout 'sub_page', only: :show

  def show
    @centre, @weeks, @all_stores = service_map \
      centre: params[:centre_id],
      centre_trading_hour: params[:centre_id],
      store: {centre: params[:centre_id], per_page: "all"}

    @centre_trading_hour = @weeks.flatten.select{|hour| hour.date == Time.now.in_time_zone(@centre.timezone).strftime("%Y-%m-%d")}.first

    @hero = Hashie::Mash.new heading: 'Shopping Hours', image: 'shopping-hours', icon: 'icon--hours'
    meta.push(
      page_title: "Shopping Hours at #{@centre.name}",
      description: "Find #{@centre.name}'s opening and trading hours for today, this week and special shopping days"
    )
  end

end