class Meta < Hashie::Mash

  def push(to_add)
    self.merge! to_add
  end

  def page_title
    [title, "Westfield"].join " | "
  end

end