class CurationsController < ApplicationController

  def show
    @centre, @curation = service_map \
      centre: params[:centre_id],
      curation: { code: params[:slug], centre: params[:centre_id] }

    meta.push @curation.meta
    meta.push \
      page_title: "#{@curation.name} at #{@centre.name}",
      description: @curation.description
  end

end
