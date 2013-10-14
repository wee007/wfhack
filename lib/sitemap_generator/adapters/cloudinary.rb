module SitemapGenerator
  class CloudinaryAdapter
    def write(location, raw_data)
      # Write to disk
      SitemapGenerator::FileAdapter.new.write(location, raw_data)

      # Construct the path for cloudinary (it requires a rails root relative path)
      path = Pathname.new(location[:public_path] + location[:filename]).relative_path_from(Rails.root).to_s

      file = Cloudinary::Uploader.upload(path, public_id: "sitemap.xml.gz", resource_type: :raw)
      pp "Uploaded sitemap to #{file["url"]}"
    end
  end
end