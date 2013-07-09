class Centre < Hashie::Mash
  def self.build(array_or_hash)
    if array_or_hash.is_a?(Hash)
      new(array_or_hash)
    else
      array_or_hash.map{|centre| new centre}
    end
  end
end
