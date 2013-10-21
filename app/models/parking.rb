class Parking < Hashie::Mash
  def rates
    @rates ||= parking_rates.map{|v| ParkingRate.new(v) }
  end

  def info?
    additional_parking_information.present? || valet_parking_instructions.present?
  end

  def terms_conditions?
    credit_card_surcharge_amount.to_i > 0 || pdf_ref.present?
  end
end
