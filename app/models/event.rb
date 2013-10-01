class Event < Hashie::Mash

  # TODO: remove this
  def title
    super || name
  end

  def date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
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

  def image
    _links['image']['href']
  end

  def to_param
    id
  end

  def kind
    self.class.name.downcase
  end

  def meta
    Meta.new title: title,
             image: image
  end

end
