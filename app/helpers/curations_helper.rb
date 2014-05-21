module CurationsHelper

  def products_path retailer
    if params[:centre_id]
      centre_products_path centre_id: params[:centre_id], retailer: [ retailer[:code] ]
    else
      super retailer: [ retailer[:code] ]
    end
  end

end
