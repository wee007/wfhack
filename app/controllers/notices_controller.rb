class NoticesController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, notices = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      notices = CentreServiceNoticesService.fetch centre: params[:centre_id], active: true
    end
    @centre = CentreService.build centre
    @notices = CentreServiceNoticesService.build notices

    meta.push(
      page_title: "Notices and Activities at #{@centre.name}",
      description: "Find the latest notices and activities for children and adults taking place at #{@centre.name}"
    )
  end

  def show
    centre, notice = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      notice = CentreServiceNoticesService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @notice = CentreServiceNoticesService.build notice

    meta.push @notice.meta
    meta.push(
      title: @notice.name,
      page_title: "#{@notice.name} at #{@centre.name}",
      description: "At #{@centre.name}, #{@notice.description}"
    )
  end

end
