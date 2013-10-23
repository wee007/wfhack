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

  def event_times_grouped_by_date
    occurrences.inject({}) do |acc, session|
      start_date = Date.parse(session[:start])
      (acc[start_date] ||= []) << session
      acc
    end
  end

  def kind
    self.class.name.downcase
  end

  def meta
    Meta.new title: title,
             image: image
  end

end
