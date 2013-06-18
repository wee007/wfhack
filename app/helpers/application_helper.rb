module ApplicationHelper

	def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
	end

  def in_lightbox?
    false #TODO Add logic here to check if we are in a lightbox.
  end

end
