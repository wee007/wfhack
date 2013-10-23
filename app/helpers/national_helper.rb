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
          gravity: 'center',
          effect: 'blur:300',
          fetch_format: 'auto',
          opacity: 65,
          background: 'rgb:000'
        },
        {
          width: width,
          height: height,
          effect: 'multiply',
          overlay: 'asset:black-gradient-overlay-1def4660b3215cc2137cd8288cd90fb5'
        }
      ]
    )
  end

end