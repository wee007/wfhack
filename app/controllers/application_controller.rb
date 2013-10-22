class ApplicationController < ActionController::Base

  unless Rails.env.development?
    rescue_from Service::API::Errors::Error do |e|
      SplunkLogger::Logger.error "ServiceError", "service", e.service, "code", e.code, "method", e.method, "url", e.url
      respond_to_error code
    end
  end

  # Blanket site wide cache of one hour.
  before_action do
    expires_in 1.hour, public: true unless Rails.env.development? || Rails.env.test?
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render_404
    handle_error(NullObject.new :status => 404)
  end

  def handle_error(null_object=nil)
    null_object ||= NullObject.new
    respond_to_error null_object.status
  end

  def respond_to_error(status)
    file_name = "#{Rails.root}/public/#{status}.html"
    error_file = File.exist?(file_name) ? file_name : "#{Rails.root}/public/503.html"
    respond_to do |format|
      format.html { render :file => error_file, :layout => false, :status => status }
      format.xml  { head status }
      format.json { head status }
      format.any  { head status }
    end
  end

  def meta
    gon.meta ||= Meta.new
  end
  helper_method :meta

end
