module Routes
  module ProductRoutes
    def self.draw(context)
      context.instance_eval do
        get 'products' => 'products#index'
        get 'products/:id/redirection' => 'products#redirection', as: 'product_redirection'
        get 'products/:id/social-share' => 'social_shares#show', as: 'product_social_share', kind: 'product'
        get 'products/:super_cat' => 'products#index', as: 'products_super_cat'
        get 'products/:super_cat/:category' => 'products#index', as: 'products_category'
        get 'products/:retailer_code/:product_name/:id' => 'products#show', as: 'product'
      end
    end
  end
end

CustomerConsole::Application.routes.draw do
  if !Rails.env.production?
    resources :styleguides, only: [:index, :show]
    get 'styleguide', to: redirect('/styleguides')

    get 'robots.txt' => 'robots#not_welcome'
  end

  get 'robots.txt' => 'robots#welcome'
  get 'sitemap.xml.gz' => 'robots#sitemap'

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'
  get 'api', to: redirect('/api/index.html') # This lets /api work, not just /api/
  get 'terms-conditions' => 'pages#terms_conditions'
  get 'privacy-policy' => 'pages#privacy_policy'
  Routes::ProductRoutes.draw self
  get '/au/shopping/*request_path' => 'redirector#shopping'


 # everything needs to go above centres
  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    get 'events/:id/social-share' => 'social_shares#show', as: 'event_social_share', kind: 'event'
    resources :deals, only: [:index]
    get 'deals/:id/social-share' => 'social_shares#show', as: 'deal_social_share', kind: 'deal'
    get 'deals/:retailer_code/:id' => 'deals#show', as: 'deal'
    resources :movies, only: [:index]
    get 'movies/:id/social-share' => 'social_shares#show', as: 'movie_social_share', kind: 'movie'
    get 'movies/:movie_name/:id' => 'movies#show', as: 'movie'
    resources :notices, only: [:show]
    get 'notices/:id/social-share' => 'social_shares#show', as: 'notice_social_share', kind: 'centre_service_notices'
    resources :stores, only: [:index]
    get 'stores/:retailer_code/:id' => 'stores#show', as: 'store'
    get 'hours', to: 'centre_hours#show'
    get 'info', to: 'centre_info#show'
    get 'services', to: 'centre_service_details#show'
    get 'canned-searches/:id/social-share' => 'social_shares#show', as: 'canned_search_social_share', kind: 'canned_search'
    Routes::ProductRoutes.draw self
  end

  root 'centres#index'
end
