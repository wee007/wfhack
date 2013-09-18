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

end