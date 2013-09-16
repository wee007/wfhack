module ParkingsHelper
  
  def display_parking_rate(rate)
    return "FREE" unless rate.to_f > 0
    "$#{rate}"
  end
  
end