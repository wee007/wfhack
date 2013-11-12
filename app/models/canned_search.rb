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
    Meta.new title: name,
             image: image
  end

  def icon
    detect_tile || "search"
  end

  def tag_line
    case detect_tile
    when "products"
      "View collection"
    when "store"
      "View store details"
    when "hours"
      "View shopping hours"
    when "info"
      "View details"
    when "notices"
      "View details"
    when "service"
      "View details"
    end
  end

  private

  def detect_tile
    case url
    when /[a-z]+\/products/
      "products"
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
    end
  end
  
end
