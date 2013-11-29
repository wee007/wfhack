module TileHelper

  def tile_url(centre, result)
    case result.kind.to_s
    when 'product'
      centre ? centre_product_url(centre, result.to_param) : product_url(result.to_param)
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
    when 'movie'
      centre_movie_url(centre_id: centre, id: result.id, movie_name: result.title.to_slug)
    end
  end

  def tile_social_share_url(centre, kind, id)
    if centre
      send "centre_#{kind}_social_share_url", centre, id
    else
      send "#{kind}_social_share_url", id
    end
  end

  def pin_board(rows, &block)
    render layout: "/layouts/pin_board", locals: { rows: rows }, &block
  end

  def tile(kind, data)
    # TODO rethink this whole begin / rescue idea
    begin
      render partial: "/shared/tiles/#{kind}", layout: '/layouts/tile', locals: data
    rescue => e # Log and contiune of a tile errors.
      SplunkLogger::Logger.error \
        "TileError",
        "kind", kind,
        "id", data[:result].to_param,
        "error", e

      return nil
    end

  end

end
