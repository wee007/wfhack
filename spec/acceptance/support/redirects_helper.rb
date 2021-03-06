shared_context "redirects" do
  def internal_redirect_list
    [
      { :from => '/geelong/wifi', :to => '/geelong/' },
      { :from => '/au/brands/my-brand', :to => '/products?brand[]=my-brand' },
      { :from => '/au/retailers/supre', :to => '/products?retailer=supre' },
      { :from => '/m/au/centres/strathpine/shopping-hours', :to => '/strathpine/hours' },
      { :from => '/m/au', :to => '/' },
      { :from => '/au', :to => '/' },
      { :from => '/m/au/products', :to => '/products/' },
      { :from => '/au/products', :to => '/products/' },
      { :from => '/au/westfield-centres', :to => '/' },
      { :from => '/sydney/centre-information/shopping-hours', :to => '/sydney/hours' },
      { :from => '/sydneycentralplaza/', :to => '/sydney/' },
      { :from => '/m/au/centres/sydney', :to => '/sydney/' },
      { :from => '/sydneycentralplaza/hours', :to => '/sydney/hours' },
      { :from => '/centres', :to => '/' },
      { :from => '/au/shopping/womens-fashion-accessories', :to => '/products?super_cat=womens-fashion-accessories' },
      { :from => '/au/shopping/womens-fashion-accessories/womens-clothing/womens-dresses', :to => '/products?category=womens-dresses' }
    ]
  end
  
  def external_redirect_list
    [
      { :from => '/unsubscribe', :to => 'https://secure.westfield.com.au/unsubscribe/' },
      { :from => '/flatlay', :to => 'http://flatlay.westfield.com.au/' },
      { :from => '/giftcard', :to => 'https://www.westfieldgiftcards.com.au/Online/' },
      { :from => '/giftcards', :to => 'https://www.westfieldgiftcards.com.au/Online/' }
    ]
  end
end
