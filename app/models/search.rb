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

end