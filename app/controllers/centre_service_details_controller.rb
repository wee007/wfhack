class CentreServiceDetailsController < ApplicationController

  layout 'sub_page', only: :show

  def show
    @centre, @centre_service_details = service_map \
      centre: params[:centre_id],
      centre_service_detail: params[:centre_id]

    @concierge = @centre_service_details.service_type_details('concierge') if @centre_service_details.present?
    @hero = Hashie::Mash.new heading: 'Centre services', image: 'centre-services', icon: 'icon--service'

    meta.push(
      page_title: "#{@centre.name} Centre Services",
      description: "Centre Concierge, Giftcards and a list of services available at #{@centre.name}"
    )
  end

end