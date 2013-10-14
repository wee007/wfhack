namespace :sitemap do
  desc "Upload sitemap to cloudinary"
  task upload: :environment do
    Cloudinary::Uploader.upload('public/sitemap.xml.gz', public_id: "sitemap.xml.gz", resource_type: :raw)
  end
end
