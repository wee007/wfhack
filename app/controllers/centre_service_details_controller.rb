class CentreServiceDetailsController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre, centre_service_details = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      centre_service_details = CentreServiceDetailService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @centre_service_details = CentreServiceDetailService.build centre_service_details
    @concierge = @centre_service_details.service_type_details('concierge') if @centre_service_details.present?
    @hero = Hashie::Mash.new heading: 'Centre services', image: 'centre-services', icon: 'icon--service'

    meta.push(
      page_title: "#{@centre.name} Centre Services",
      description: "Centre Concierge, Giftcards and a list of services available at #{@centre.name}"
    )
  end

end