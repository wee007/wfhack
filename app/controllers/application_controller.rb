class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render_404
    handle_error(NullObject.new :status => 404)
  end

  def handle_error(null_object=nil)
    null_object ||= NullObject.new
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/#{null_object.status}", :layout => false, :status => null_object.status }
      format.xml  { head null_object.status }
      format.json { head null_object.status }
      format.any  { head null_object.status }
    end
  end

end
