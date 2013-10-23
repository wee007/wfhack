module TileHelper

  def tile_url(centre, result)
    case result.kind.to_s
    when 'product'
      options = {retailer_code: result.retailer_code, sku: result.sku}
      centre ? centre_product_url(centre, options) : product_url(options)
    when 'event'
      centre_event_url(centre, result)
    when 'deal'
      centre_deal_url(centre, retailer_code: result.retailer_code, id: result)
    when 'canned_search'
      begin    
        u = URI(result.url)
        u = URI.join(root_url(:only_path => false), result.url) unless u.host
        u.to_s
      rescue
        result.url
      end
    end
  end

  def pin_board(rows, &block)
    render layout: "/layouts/pin_board", locals: { rows: rows }, &block
  end

  def tile(kind, data)
    render partial: "/shared/tiles/#{kind}", layout: '/layouts/tile', locals: data
  end

end
