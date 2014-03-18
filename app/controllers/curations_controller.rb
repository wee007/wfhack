class CurationsController < ApplicationController

  before_action :setup

  def show
    @centre, @curation = service_map \
      centre: params[:centre_id],
      curation: params[:slug]

    meta.push \
      page_title: "#{@curation.name} at #{@centre.name}",
      description: @curation.description
  end

  protected

  def setup
    centres = CentreService.find :all, country: 'au'
    @centres = centres.group_by { |c| c.state } if centres.present?
    meta.push page_title: '', description: ''
  end

end
