class Event < Hashie::Mash

  # TODO: remove this
  def title
    super || name
  end

  def start(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def finish(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def body
    (super || '').split(/\r?\n/).collect &:strip
  end

  def image(options = {})
    options = {width: 400, ref: image_ref}.merge(options)
    ImageService.transform options
  end

  def to_param
    id
  end

  def kind
    self.class.name.downcase
  end

  def meta
    {title: title, image: image}
  end

end
