module CentresHelper

  def social_media
    social_media = [
      @centre.facebook,
      @centre.twitter,
      @centre.google_plus,
      @centre.instagram,
      @centre.pinterest,
      @centre.youtube
    ]

    social_media.keep_if { |social_media| social_media.present? }
  end


  def google_static_maps_url(options)
    # Decode the key
    key = Base64.urlsafe_decode64 AppConfig.google_maps_business_key

    image = options[:scale] == 1 ? 'icon_map_pointer.png' : 'icon_map_pointer@2x.png'

    # Build up the url to sign
    to_sign = '/maps/api/staticmap?' + {
      markers: "scale:#{options[:scale]}|icon:#{image_path(image)}|#{options[:latitude]},#{options[:longitude]}",
      zoom: 15,
      size: "#{options[:width]}x#{options[:height]}",
      scale: options[:scale],
      sensor: false,
      client: AppConfig.google_maps_business_client_id
    }.to_query

    # Build the signature
    signature = Base64.urlsafe_encode64 OpenSSL::HMAC.digest('sha1', key, to_sign)

    # Return the google maps url
    "http://maps.googleapis.com#{to_sign}&signature=#{signature}"
  end

  def getting_here_map_url(centre, scale = 1)
    google_static_maps_url latitude: centre.latitude,
                           longitude: centre.longitude,
                           height: 280,
                           width: 980,
                           scale: scale
  end

  def hero_image(centre_id, height, width)
    image_path(
      "heroes/#{centre_id}.jpg",
      transformation: [
        {
          width: width,
          height: height,
          crop: 'fill',
        },
        {
          width: width,
          height: height,
          effect: 'multiply',
          overlay: 'asset:black-overlay-1805e3ae919b74a1ed2cff673434e6f9',
          opacity: '50'
        }
      ]
    )
  end

end