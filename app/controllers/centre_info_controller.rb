class CentreInfoController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @hero = Hashie::Mash.new heading: 'Centre information', image: 'centre-info'
    meta.push title: "#{@centre.short_name} Information"
  end

end