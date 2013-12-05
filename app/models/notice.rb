class Notice < Hashie::Mash

  def self.build(array_or_hash)
    if array_or_hash.is_a?(Hash)
      new(array_or_hash)
    elsif array_or_hash.is_a?(Array)
      array_or_hash.map{|centre| new centre}
    else
      nil
    end
  end

  def meta
    Meta.new id: id,
             title: name,
             twitter_title: "Check out this #{name}",
             image: image,
             kind: kind
  end

  def date(strftime = nil)
    parsed_time = Time.parse(publish_date_time)
    strftime ? parsed_time.strftime(strftime) : parsed_time
  end

  def kind
    self.class.name.downcase
  end

end
