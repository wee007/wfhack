class RobotsController < ApplicationController

  # Stream the sitemap.xml.gz index file through rails
  def sitemap
    require 'open-uri'
    io = open sitemap_index_url, proxy: AppConfig.proxy
    send_data io.read, content_type: io.meta['content-type'], disposition:'inline'
  end

  private
  def sitemap_index_url
    sitemap_filename = "sitemap.xml.gz"
    sitemap_filename = Rails.env + sitemap_filename unless Rails.env == 'production'
    URI.parse("#{request.scheme}://#{Cloudinary::SHARED_CDN}/#{Cloudinary.config.cloud_name}/raw/upload/#{sitemap_filename}").to_s
  end
end