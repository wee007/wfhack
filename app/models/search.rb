class Search < Hashie::Mash

  def hard_redirect?
    results.count == 1 && results.centre_information
  end

  def first_result_uri_path
  	results["centre_information"].first["attributes"]["path"]
  end

  def sort
    results.sort do |a,b|
      ordering_on_type(a.first) <=> ordering_on_type(b.first)
    end
  end

  private

  # Order by type_order_list - if we can't find a matching type, move it to the end
  def ordering_on_type type
    type_order_list =
     [
      "centre_information",
      "events"
     ]
    type_order_list.index(type) || 9999
  end

end