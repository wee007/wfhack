module TileHelper

  def tile_url(centre, result)
    case result.kind.to_s
    when 'product'
      centre_product_url(centre, retailer_code: result.retailer_code, sku: result.sku)
    when 'event'
      centre_event_url(centre, result)
    when 'deal'
      centre_deal_url(centre, result)
    end
  end

end
