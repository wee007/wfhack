require 'service_helper'
require 'westfield_uri'

module AcceptanceSupportHelpers
  def this_weeks_centre_hours
    this_weeks_hours_for 'centre'
  end
  
  def this_weeks_store_hours
    this_weeks_hours_for 'store'
  end
  
  def this_weeks_hours_for(type)
    from_date = Time.now.in_time_zone('Sydney').beginning_of_week
    to_date = from_date + 6.days
    url = case type
    when 'centre'
      "#{ServiceHelper.uri_for('trading-hour')}/centre_trading_hours/range.json?centre_id=bondijunction&from=#{from_date.strftime('%Y-%m-%d')}&to=#{to_date.strftime('%Y-%m-%d')}"
    when 'store'
      "#{ServiceHelper.uri_for('trading-hour')}/store_trading_hours/range.json?store_id=4565&centre_id=bondijunction&from=#{from_date.strftime('%Y-%m-%d')}&to=#{to_date.strftime('%Y-%m-%d')}"
    end
    puts "Calling API: #{url}"
    visit (url)
    JSON.parse(page.body)
  end
  
  def expected_hours_string(hour)
    "#{DateTime.parse(hour["date"]).strftime("%A")} #{DateTime.parse(hour["opening_time"]).to_s(:hour_minute_period).lstrip} – #{DateTime.parse(hour["closing_time"]).to_s(:hour_minute_period).lstrip}"
  end
end