class CentreTradingHour < Hashie::Mash

  def self.build(array_or_hash)
    if array_or_hash.is_a?(Hash)
      new array_or_hash
    elsif array_or_hash.is_a?(Array)
      array_or_hash.map{ |trading_hours| new trading_hours }
    else
      nil
    end
  end

  def christmas?
    hour_type == 'christmas'
  end

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