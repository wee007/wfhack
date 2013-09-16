class CentreInfoController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre, parking = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      parking = ParkingService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @parking = ParkingService.build parking
    @hero = Hashie::Mash.new heading: 'Centre information', image: 'centre-info'
    meta.push title: "#{@centre.short_name} Information"
  end

end