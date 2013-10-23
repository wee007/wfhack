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
    case url
    when /[a-z]+\/products/
      "products"
    when /[a-z]+\/stores/
      "store"
    when /[a-z]+\/hours/
      "hours"
    when /[a-z]+\/info/
      "info"
    when /[a-z]+\/services/
      "service"
    else
      "search"
    end
  end
  
end
