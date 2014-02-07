class CentreInfoController < ApplicationController

  layout 'sub_page', only: :show

  def show
    @centre, @parking, @notices = service_map \
      centre: params[:centre_id],
      parking: params[:centre_id],
      centre_service_notices: {centre: params[:centre_id], active: true}

    @hero = Hashie::Mash.new heading: 'Centre information', image: 'centre-info', icon: 'icon--info'
    meta.push(
      page_title: "#{@centre.name} Directions and Parking Information",
      description: "Get directions to #{@centre.name} as well as parking information and contact details"
    )
  end

end
