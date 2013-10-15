class RobotsController < ApplicationController
  # /robots.txt
  def index
    @sitemap_url = sitemap_url
    render :index, layout: false, content_type: Mime::TEXT
  end

  def sitemap
    redirect_to sitemap_url
  end

  private
  def sitemap_url
    URI.parse("#{request.scheme}://#{Cloudinary::SHARED_CDN}/#{Cloudinary.config.cloud_name}/raw/upload/sitemap.xml.gz").to_s
  end
end