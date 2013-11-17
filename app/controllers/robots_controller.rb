class RobotsController < ApplicationController

  # Used for production
  # See config/routes.rb
  def welcome
    render text_attr.merge(file: Rails.root.join('public/robots-welcome.txt'))
  end

  # Used for non-production
  # See config/routes.rb
  def not_welcome
    render text_attr.merge(file: Rails.root.join('public/robots-not-welcome.txt'))
  end

  # Stream the sitemap.xml.gz index file through rails
  def sitemap
    require 'open-uri'
    io = open sitemap_index_url, proxy: AppConfig.proxy
    send_data io.read, content_type: io.meta['content-type'], disposition:'inline'
  end

  private
  def sitemap_index_url
    sitemap_filename = "sitemap.xml.gz"
    sitemap_filename = "#{Rails.env}_#{sitemap_filename}" unless Rails.env == 'production'
    URI.parse("#{request.scheme}://#{Cloudinary::SHARED_CDN}/#{Cloudinary.config.cloud_name}/raw/upload/#{sitemap_filename}").to_s
  end

  def text_attr
    {
      layout: false,
      content_type: Mime::TEXT
    }
  end
end