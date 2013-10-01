module ParkingsHelper
  
  def display_parking_rate(rate, message = "FREE")
    return message unless rate.to_f > 0
    "$#{rate}"
  end
  
end