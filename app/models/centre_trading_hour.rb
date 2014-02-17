class CentreTradingHour < Hashie::Mash

  def date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def opening_time(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def closing_time(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

end