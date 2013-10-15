module NationalHelper

  def context_aware_link(centre)
    if params[:controller] == 'pages'
      centre_path centre
    else
      url_for centre_id: centre.code
    end
  end

  def centre_tile_image(centre_id, width, height)
    image_path(
      "heroes/#{centre_id}.jpg",
      transformation: [
        {
          width: width,
          height: height,
          crop: 'fill',
          effect: 'blur:300',
          format: 'auto'
        }
      ]
    )
  end

end