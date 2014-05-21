module CurationsHelper

  def centre_or_national_products_path retailer
    if params[:centre_id]
      centre_products_path centre_id: params[:centre_id], retailer: [ retailer[:code] ]
    else
      products_path retailer: [ retailer[:code] ]
    end
  end

end
