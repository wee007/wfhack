module NationalHelper

  def context_aware_link(centre)
    if params[:controller] == 'pages'
      centre_path centre
    else
      url_for centre_id: centre.code
    end
  end

end