class Event < Hashie::Mash

  def start(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def finish(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def body
    (super || '').split(/\r?\n/)
  end

end
