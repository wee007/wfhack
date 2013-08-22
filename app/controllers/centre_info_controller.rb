class CentreInfoController < ApplicationController

  layout 'hero', only: :show

  def show
    centre = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @hero = Hashie::Mash.new heading: 'Centre information', image: 'hours'
    meta.push title: "#{@centre.short_name} Information"
  end

end