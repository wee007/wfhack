require 'rubygems'
require 'sitemap_generator'
require 'service_helper'
require 'service_api'

host = 'http://westfield.com.au'
SitemapGenerator::Sitemap.default_host = host
Rails.application.routes.default_url_options[:host] = host

SitemapGenerator::Sitemap.create do
  add '/', changefreq: 'daily', priority: 0.9

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

  pp "There are #{product_count} products, which will be collected #{rows} at a time"

  product_responses = []
  (1..pages).to_a.each do |index|
    pp "Getting product page #{index}"
      product_responses << Service::API.get(product_search_url, page: index, rows: rows)
  end

  pp "#{centres.count} centres"

  centres.each do |centre|
    add centre_path(centre.code), lastmod: centre.updated_at
    add centre_events_path(centre.code), priority: 0.5
    add centre_deals_path(centre.code), priority: 0.5
    add centre_movies_path(centre.code), priority: 0.5
    add centre_stores_path(centre.code), priority: 0.5
    add centre_hours_path(centre.code), priority: 0.5
    add centre_info_path(centre.code), priority: 0.5

    # Stores
    Service::API.get(stores_uri, centre_id: centre.code).each do |store|
      add centre_store_path(centre.code, store.retailer_code, store.id), priority: 0.5, lastmod: store.updated_at
    end
  end

  product_responses.each do |pr|
    pr.results.each do |product|
      add product_path(product.retailer_code, product.sku), priority: 0.5, lastmod: product.updated_at
    end
  end
end
