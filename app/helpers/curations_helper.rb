module CurationsHelper

  NumberOfProducts = 10

  ProductCloudinaryUrls = %w[
    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,h_474,w_469/http://res.cloudinary.com/wlabs/image/upload/v1384479265/lpyfmlkrpvs6yuedylxw.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,h_474,w_469/http://res.cloudinary.com/wlabs/image/upload/v1393381198/adhzebpx2ydbnelp3uuu.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,h_474,w_469/http://res.cloudinary.com/wlabs/image/upload/v1389193935/vi5p54hlo652kqrgtnew.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,h_474,w_469/http://res.cloudinary.com/wlabs/image/upload/v1381316112/oxtlmtu5osxdnati57wi.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_limit,f_auto,w_289/http://res.cloudinary.com/wlabs/image/upload/v1393290790/jgp1zlrmdihr1ujsamai.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,w_289/http://res.cloudinary.com/wlabs/image/upload/v1381336879/l8itsnowlxzljr7vsd6d.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_lpad,f_auto,h_474,w_469/http://res.cloudinary.com/wlabs/image/upload/v1393467025/yxqkvz9e9fionmsxk287.jpg
  ]

  def curated_products
    (1..NumberOfProducts).to_a.map { |product_id| { id: product_id, image_url: ProductCloudinaryUrls.sample }}
  end
end