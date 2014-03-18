module CurationsHelper

  NumberOfProducts = 50

  ProductCloudinaryUrls = %w[

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1384919100/z2vm1iecj7xgl4dknql4.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1384479265/lpyfmlkrpvs6yuedylxw.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1393381198/adhzebpx2ydbnelp3uuu.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1389193935/vi5p54hlo652kqrgtnew.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1392717561/gb98csm4rvxdicfxsnqm.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1381316112/oxtlmtu5osxdnati57wi.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1393290790/jgp1zlrmdihr1ujsamai.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1381336879/l8itsnowlxzljr7vsd6d.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1382541041/ylsgkguyut59unrh8udf.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1386718425/tvvuer6s6mq9xygcgmbe.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1394210320/pwaqtftmrbpnprk1qvwb.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1391469004/ei2rj0fmr2xim9dpyflq.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1390664838/zbno8yfhxnaznkd1otb6.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1390497712/wyw5lumg6sty7sv8sf7y.jpg

    http://res.cloudinary.com/wlabs/image/fetch/c_pad,w_%d,f_auto/http://res.cloudinary.com/wlabs/image/upload/v1392822928/wvahaxjy2dvmo6bbr2tg.jpg
  ]

  def curated_products
    (1..NumberOfProducts).to_a.map { |product_id| { id: product_id, image_url: ProductCloudinaryUrls.sample }}
  end

end