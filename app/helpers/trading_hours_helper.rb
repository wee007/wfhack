module TradingHoursHelper

  def this_monday_date
    Date.commercial( Date.today.year, Date.today.cweek, 1 )
  end

  def next_monday_date
    Date.commercial( Date.today.year, ( Date.today+7 ).cweek, 1 )
  end

end