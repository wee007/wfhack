module ProductsHelper

  # This controller is either scoped by a centre or not,
  # a simple helper to tidy the views
  def pb_path
    (@centre.nil?) ? products_path : centre_products_path(@centre)
  end

end
