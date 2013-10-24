class CentreInfoController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre, parking, notices = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      notices = CentreServiceNoticesService.fetch(:centre => params[:centre_id])
      parking = ParkingService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @parking = ParkingService.build parking
    @notices = CentreServiceNoticesService.build notices
    @hero = Hashie::Mash.new heading: 'Centre information', image: 'centre-info', icon: 'icon--info'
    meta.push(
      page_title: "#{@centre.name} Directions and Parking Information",
      description: "Get directions to #{@centre.name} as well as parking information and contact details"
    )
  end

end
