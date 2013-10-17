require Rails.root.join('lib/sitemap_generator/adapters/cloudinary')

host = WestfieldUri::Console.uri_for('customer').to_s
SitemapGenerator::Sitemap.default_host = host
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::CloudinaryAdapter.new
Rails.application.routes.default_url_options[:host] = host

begin
  SitemapGenerator::Sitemap.create do
    add '/', changefreq: 'daily', priority: 1.0

    centres_uri = URI("#{ServiceHelper.uri_for('centre')}/centres.json?country=au")
    stores_uri = URI("#{ServiceHelper.uri_for('store')}/stores.json")
    product_search_url = URI("#{ServiceHelper.uri_for('product')}/products/search.json")

    centres = Service::API.get(centres_uri)
    stores = Service::API.get(stores_uri)

    # Hit the product_search_url once to discover the amount of products / pages,
    # then loop over those.
    product_count = Service::API.get(product_search_url, rows: 1)['count']
    rows = 500
    pages = (product_count.to_f / rows.to_f).ceil

    Rails.logger.info "[SITEMAP] There are #{product_count} products, which will be collected #{rows} at a time"

    product_responses = []
    (1..pages).to_a.each do |index|
      Rails.logger.info "[SITEMAP] Getting product page #{index}"
      product_responses << Service::API.get(product_search_url, page: index, rows: rows)
    end

    Rails.logger.info "[SITEMAP] #{centres.count} centres"

    centres.each do |centre|
      add centre_path(centre.code), priority: 0.8, lastmod: centre.updated_at
      add centre_events_path(centre.code), priority: 0.6
      add centre_deals_path(centre.code), priority: 0.6
      add centre_movies_path(centre.code), priority: 0.6
      add centre_stores_path(centre.code), priority: 0.6
      add centre_hours_path(centre.code), priority: 0.6
      add centre_info_path(centre.code), priority: 0.6

      # Stores
      Service::API.get(stores_uri, centre_id: centre.code).each do |store|
        next unless centre.code and store.retailer_code and store.id
        add centre_store_path(centre.code, store.retailer_code, store.id), priority: 0.6, lastmod: store.updated_at
      end
    end

    product_responses.each do |pr|
      pr.results.each do |product|
        next unless product.retailer_code and product.sku
        add product_path(product.retailer_code, product.sku), priority: 0.8, lastmod: product.updated_at
      end
    end
  end
rescue => e
  Rails.logger.info "SITEMAP error=#{e.message} phase=generation"
  raise e
end
