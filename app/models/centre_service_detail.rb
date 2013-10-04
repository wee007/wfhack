class CentreServiceDetail < Hashie::Mash
  def service_type_details(type)
    details.keep_if { |detail| detail[:type].eql?(type) }.first
  end
end
