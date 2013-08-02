class NullObject < Hashie::Mash
  def name
    "Page"
  end
  def status
    self[:status] || 500
  end
end
