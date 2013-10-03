class MovieSession < Hashie::Mash
  
  def morning?
    start_time.strftime("%H") < '12'
  end
  
  def afternoon?
    start_time.strftime("%H") >= '12'
  end
  
  def start_time
    Time.parse(super)
  end
  
end