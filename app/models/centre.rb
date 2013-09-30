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

  def description
    case type
    when "aspirational"
      "Find your favourite store and the newest shops for fashion, beauty, lifestyle and fresh food only at #{name}"
    when "premium"
      "Enjoy the ultimate shopping experience at #{name} with the latest Australian & international stores, premium brands, dining, events & more"
    when "value"
      "The best in fresh food and great deals on fashion, beauty and lifestyle products from your favourite stores only at #{name}"
    end
  end

  def to_param
    code
  end

end
