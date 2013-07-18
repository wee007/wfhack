CustomerConsole::Application.routes.draw do
  if Rails.env.development?
    resources :styleguides, only: [:index, :show]
    get 'styleguide' => redirect('/styleguides')
  end

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'

  get 'api', to: redirect('api/index.html') # This lets /api work, not just /api/

  get 'visitor(/:action)', to: 'visitor#index'

  mount AaaClient::Engine => "/aaa", as: 'aaa_client'

 # everything needs to go above centres
  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    resources :deals, only: [:index, :show]
    resources :movies, only: [:index, :show]
    resources :stores, only: [:index, :show]
    resources :products, only: [:index]
    get 'products/:retailer_code/:sku' => 'products#show', constraints: {id: /.+/}, as: 'product'
    resources :trading_hours, only: [:index]
    member do
      get 'product_stream'
    end
  end

  root 'centres#index'

end
