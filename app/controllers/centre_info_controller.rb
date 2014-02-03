class CentreInfoController < ApplicationController

  layout 'sub_page', only: :show

  def show
    @centre, @parking, @notices, centre_trading_hour = service_map \
      centre: params[:centre_id],
      parking: params[:centre_id],
      centre_service_notices: {centre: params[:centre_id], active: true},
      centre_trading_hour: params[:centre_id]

    # move this to application controller
    @centre_trading_hour = centre_trading_hour.flatten.select{|hour| hour.date == Time.now.in_time_zone(@centre.timezone).strftime("%Y-%m-%d")}.first

    @hero = Hashie::Mash.new heading: 'Centre information', image: 'centre-info', icon: 'icon--info'
    meta.push(
      page_title: "#{@centre.name} Directions and Parking Information",
      description: "Get directions to #{@centre.name} as well as parking information and contact details"
    )
  end

end
