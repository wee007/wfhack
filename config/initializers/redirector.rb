require 'csv'

def redirector_read_csv(filename)
  categories = {}

  CSV.foreach(filename) do |row|
    categories[row[0].strip] = row[1].strip
  end

  categories
end

REDIRECTOR_DELETED_CATEGORIES = redirector_read_csv("lib/assets/deleted_categories.csv")
