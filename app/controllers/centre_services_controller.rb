class CentreServicesController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @hero = Hashie::Mash.new heading: 'Centre services', image: 'centre-services'

    meta.push(
      page_title: "#{@centre.name} Centre Serivces",
      description: "Centre Concierge, Giftcards and a list of services available at #{@centre.name}"
    )
  end

end