class Centre < Hashie::Mash
  def self.build(array_or_hash)
    if array_or_hash.is_a?(Hash)
      new(array_or_hash)
    elsif array_or_hash.is_a?(Array)
      array_or_hash.map{|centre| new centre}
    else
      nil
    end
  end

  def to_param
    code
  end

end
