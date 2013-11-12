CustomerConsole::Application.routes.draw do
  if !Rails.env.production?
    resources :styleguides, only: [:index, :show]
    get 'styleguide', to: redirect('/styleguides')
  end

  # get 'sitemap.xml.gz' => 'robots#sitemap'

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'
  get 'api', to: redirect('/api/index.html') # This lets /api work, not just /api/
  get 'products' => 'products#index'
  get 'products/:super_cat' => 'products#index', as: 'products_super_cat'
  get 'products/:super_cat/:category' => 'products#index', as: 'products_category'

  get 'products/:id' => 'products#show', as: 'product_old'
  get 'products/:id/redirection' => 'products#redirection', as: 'product_redirection'
  get 'products/:retailer_code/:product_name/:id' => 'products#show', as: 'product'
  get 'terms-conditions' => 'pages#terms_conditions'
  get 'privacy-policy' => 'pages#privacy_policy'

  get '/au/shopping/*request_path' => 'redirector#shopping'


 # everything needs to go above centres
  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    resources :notices, only: [:show]
    resources :deals, only: [:index]
    get 'deals/:retailer_code/:id' => 'deals#show', as: 'deal'
    resources :movies, only: [:index]
    get ':centre_id/movies/:movie_name/:id' => 'movies#show', as: 'movie'
    resources :stores, only: [:index]
    get 'stores/:retailer_code/:id' => 'stores#show', as: 'store'
    get 'hours', to: 'centre_hours#show'
    get 'info', to: 'centre_info#show'
    get 'services', to: 'centre_service_details#show'

    get 'products' => 'products#index'
    get 'products/:super_cat' => 'products#index', as: 'products_super_cat'
    get 'products/:super_cat/:category' => 'products#index', as: 'products_category'

    get 'products/:id' => 'products#show', as: 'product_old'
    get 'products/:id/redirection' => 'products#redirection', as: 'product_redirection'
    get 'products/:retailer_code/:product_name/:id' => 'products#show', as: 'product'

    member do
      get 'product_stream'
    end
  end

  root 'centres#index'
end
