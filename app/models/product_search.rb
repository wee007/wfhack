class ProductSearch < Hashie::Mash

  def categories
    output = facets.detect{|f| ["super_cat", "category", "sub_category"].include? f.field }
    output ? output['values'] : []
  end

  def brands
    output = facets.detect{|f| f.field == "brand" }
    output ? output['values'] : []
  end

  def page_count
    (fetch('count').to_f / rows.to_f).ceil
  end

  def page
    (start / rows) + 1
  end

end