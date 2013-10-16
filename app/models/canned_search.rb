class CannedSearch < Hashie::Mash
  def image
    image_uri
  end

  def start_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def end_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end
end
