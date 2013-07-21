class Event < Hashie::Mash

  def start(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def finish(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def body
    (super || '').split(/\r?\n/).collect &:strip
  end

  def image(size = '400x400')
    ImageService.transform ref: image_ref, size: size
  end

end
