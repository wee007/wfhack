class Parking < Hashie::Mash
  def rates
    @rates ||= parking_rates.map{|v| ParkingRate.new(v) }
  end

  def terms_and_conditions_url
    "http://res.cloudinary.com/wlabs/image/upload/#{pdf_ref}.pdf"
  end

end
