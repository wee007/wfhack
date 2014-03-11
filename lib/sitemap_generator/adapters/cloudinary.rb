module SitemapGenerator
  class CloudinaryAdapter
    def write(location, raw_data)
      # Write to disk
      SitemapGenerator::FileAdapter.new.write(location, raw_data)

      # Construct the path for cloudinary (it requires a rails root relative path)
      path = Pathname.new(location[:public_path] + location[:filename]).relative_path_from(Rails.root).to_s

      file = Cloudinary::Uploader.upload(path, public_id: target_filename(location[:filename]), resource_type: :raw, invalidate: true)

      # Construct the non-versioned url
      public_path = file["url"].split("upload").first + "upload/" + file["public_id"]

      Rails.logger.info "SITEMAP success=#{public_path} phase=upload"
    rescue => e
      Rails.logger.info "SITEMAP error=#{e.message} phase=upload"
      raise e
    end

    private
    def target_filename(filename)
      if Rails.env == "production"
        filename
      else
        "#{Rails.env}_#{filename}"
      end
    end
  end
end