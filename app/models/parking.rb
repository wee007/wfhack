class Parking < Hashie::Mash
  def rates
    @rates ||= parking_rates.map{|v| ParkingRate.new(v) }
  end
end
