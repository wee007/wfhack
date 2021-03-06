class CannedSearch < Hashie::Mash

  def image
    _links['image']['href']
  end

  def start_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def end_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def kind
    "canned_search"
  end

  def meta
    Meta.new id: id,
             title: name,
             image: image,
             kind: kind
  end

  def icon
    detect_tile || "search"
  end

  def tag_line
    case detect_tile
    when "product"
      "View collection"
    when "store"
      "View store details"
    when "hours"
      "View shopping hours"
    when "deal"
      "View deals"
    else
      "View details"
    end
  end

  private

  def detect_tile
    case url
    when /[a-z]+\/products/
      "product"
    when /[a-z]+\/stores/
      "store"
    when /[a-z]+\/hours/
      "hours"
    when /[a-z]+\/info/
      "info"
    when /[a-z]+\/notices/
      "info"
    when /[a-z]+\/services/
      "service"
    when /[a-z]+\/deals/
      "deal"
    end
  end

end
