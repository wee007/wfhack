CustomerConsole::Application.routes.draw do
  if !Rails.env.production?
    resources :styleguides, only: [:index, :show]
    get 'styleguide', to: redirect('/styleguides')
  end

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'
  get 'api', to: redirect('/api/index.html') # This lets /api work, not just /api/

  get 'products' => 'products#index'
  get 'products/:retailer_code/:sku' => 'products#show', constraints: {id: /.+/}, as: 'product'

  get 'terms-conditions' => 'pages#terms_conditions'
  get 'privacy-policy' => 'pages#privacy_policy'

  get '/au/shopping/*request_path' => 'redirector#shopping'


 # everything needs to go above centres
  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    resources :deals, only: [:index]
    get 'deals/:retailer_code/:id' => 'deals#show', as: 'deal'
    resources :movies, only: [:index, :show]
    resources :stores, only: [:index]
    get 'stores/:retailer_code/:id' => 'stores#show', as: 'store'
    resources :products, only: [:index]
    get 'hours', to: 'centre_hours#show'
    get 'info', to: 'centre_info#show'
    get 'services', to: 'centre_service_details#show'
    get 'products/:retailer_code/:sku' => 'products#show', constraints: {id: /.+/}, as: 'product'
    member do
      get 'product_stream'
    end
  end

  root 'centres#index'
end
