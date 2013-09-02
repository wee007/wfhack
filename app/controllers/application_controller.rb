class ApplicationController < ActionController::Base

  if Rails.env.production? || Rails.env.uat?
    http_basic_authenticate_with name: "guest", password: "searchablemall"
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render_404
    handle_error(NullObject.new :status => 404)
  end

  def handle_error(null_object=nil)
    null_object ||= NullObject.new
    file_name = "#{Rails.root}/public/#{null_object.status}.html"
    error_file = File.exist?(file_name) ? file_name : "#{Rails.root}/public/503.html"
    respond_to do |format|
      format.html { render :file => error_file, :layout => false, :status => null_object.status }
      format.xml  { head null_object.status }
      format.json { head null_object.status }
      format.any  { head null_object.status }
    end
  end

  def meta
    gon.meta ||= Meta.new
  end
  helper_method :meta

end
