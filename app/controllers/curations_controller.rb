class CurationsController < ApplicationController

  def show
    @centre, @curation = service_map \
      centre: params[:centre_id],
      curation: params[:slug]

    meta.push \
      page_title: "#{@curation.name} at #{@centre.name}",
      description: @curation.description
  end

end
