class CentreTradingHour < Hashie::Mash

  class << self
    def build(array_or_hash)
      if array_or_hash.is_a?(Hash)
        new array_or_hash
      elsif array_or_hash.is_a?(Array)
        weeks array_or_hash.collect { |day| new day }
      else
        nil
      end
    end

    def weeks(data)
      # Group hours into weeks then reverse to they are in
      # cronilogical order.
      weeks = data.in_groups_of(7, false).reverse

      # Grap the 1st two as we always want them
      output = [weeks.pop, weeks.pop]

      # Keep grabing then next ones if they have christmas hours
      while weeks.length > 0 do
        week = weeks.pop
        output << week if week.find { |hour| hour.christmas? }
      end

      output
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