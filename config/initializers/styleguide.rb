module Styleguide
  TREE = YAML::load_file(Rails.root.join('config/styleguide.yml'))
end
