require 'hashie'

class Event < Hashie::Mash

  def start_date
    Time.parse(start).strftime '%Y-%m-%d'
  end

  def start_day_of_week
    Time.parse(start).strftime '%A'
  end

  def start_time
    Time.parse(start).strftime '%l:%M%P'
  end

  def start_month
    Time.parse(start).strftime '%b'
  end

  def start_day
    Time.parse(start).strftime '%-d'
  end

  def start_month
    Time.parse(start).strftime '%b'
  end

  def finish_time
    Time.parse(finish).strftime '%l:%M%P'
  end

  def body
    (super || '').split(/\r?\n/)
  end

end