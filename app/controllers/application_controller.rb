class ApplicationController < ActionController::Base

  unless Rails.env.development? || Rails.env.test?
    rescue_from Service::API::Errors::Error do |e|
      SplunkLogger::Logger.error "ServiceError", "service", e.service, "code", e.code, "method", e.method, "url", e.url
      respond_to_error e.code
    end

    rescue_from URI::InvalidURIError do |e|
      SplunkLogger::Logger.error "URI::InvalidURIError", e
      respond_to_error 404
    end
  end

  # Blanket site wide cache of one hour.
  before_action do
    expires_in 1.hour, public: true unless Rails.env.development? || Rails.env.test?
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

  def service_map(requests)
    responses = []

    Service::API.in_parallel do
      responses = requests.collect do |kind, options|
        klass = "#{kind.to_s.singularize}_service".classify.constantize
        if options.is_a?(Array)
          response = klass.fetch(*options)
        else
          response = klass.fetch(options)
        end
        [klass, response]
      end
    end

    responses.collect do |service, response, build_options|
      service.build response
    end

  end

end
