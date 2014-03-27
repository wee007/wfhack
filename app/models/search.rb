class Search < Hashie::Mash

  # See WSF-6243; if we have only one hardcoded result, go straight to the result.
  def hard_redirect?
    if (results.count == 1)
      # "centre_information" answers are hardcoded
      if results.first.first == "centre_information"
        return true
      end
    end
  end

  def first_result_uri_path
  	results.first.second.first["attributes"]["path"]
  end

  def sort!
    self.results = self.results.sort do |a,b|
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