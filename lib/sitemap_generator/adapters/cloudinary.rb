module SitemapGenerator
  class CloudinaryAdapter
    def write(location, raw_data)
      # Write to disk
      SitemapGenerator::FileAdapter.new.write(location, raw_data)

      # Construct the path for cloudinary (it requires a rails root relative path)
      path = Pathname.new(location[:public_path] + location[:filename]).relative_path_from(Rails.root).to_s

      file = Cloudinary::Uploader.upload(path, public_id: "sitemap.xml", resource_type: :raw)

      # Construct the non-versioned url
      public_path = file["url"].split("upload").first + "upload/" + file["public_id"]

      pp "Uploaded sitemap to #{public_path}"
    rescue => e
      Rails.logger.info "SITEMAP error=#{e.message} phase=upload"
      raise e
    end
  end
end