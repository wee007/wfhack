module ApplicationHelper

	def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
	end

end
