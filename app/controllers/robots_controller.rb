class RobotsController < ApplicationController

  # Stream the sitemap.xml.gz index file through rails
  def sitemap
    require 'open-uri'
    io = open sitemap_index_url, proxy: AppConfig.proxy
    send_data io.read, content_type: io.meta['content-type'], disposition:'inline'
  end

  private
  def sitemap_index_url
    URI.parse("#{request.scheme}://#{Cloudinary::SHARED_CDN}/#{Cloudinary.config.cloud_name}/raw/upload/sitemap.xml.gz").to_s
  end
end