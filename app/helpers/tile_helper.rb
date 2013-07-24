module TileHelper

  def tile_path(centre, result)
    case result.kind.to_s
    when 'product'
      centre_product_path(centre, retailer_code: result.retailer_code, sku: result.sku)
    when 'event'
      centre_event_path(centre, result)
    when 'deal'
      centre_deal_path(centre, result)
    end
  end

end
