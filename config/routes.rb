module Routes
  module ProductRoutes
    def self.draw(context, kind)
      context.instance_eval do
        get 'products' => "products#index_#{kind}"
        get 'products/:id/redirection' => 'products#redirection', as: 'product_redirection'
        get 'products/:id/social-share' => 'social_shares#show', as: 'product_social_share', kind: 'product'

        get 'products/:super_cat' => "products#index_#{kind}", as: 'products_super_cat'
        get 'products/:super_cat/:category' => "products#index_#{kind}", as: 'products_category'
        get 'products/:retailer_code/:product_name/:id' => "products#show_#{kind}", as: 'product'
      end
    end
  end
end

CustomerConsole::Application.routes.draw do

  resources :styleguide, only: [:index, :show] do
    get '/:file' => 'styleguide#static'
  end

  if !Rails.env.production?
    get 'robots.txt' => 'robots#not_welcome'
  end

  get 'robots.txt' => 'robots#welcome'
  get 'sitemap(:id).xml.gz' => 'robots#sitemap'

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'
  get 'api', to: redirect('/api/index.html') # This lets /api work, not just /api/
  get 'terms-conditions' => 'pages#terms_conditions'
  get 'privacy-policy' => 'pages#privacy_policy'
  get 'products-xhr' => "products#index_xhr", as: 'product_xhr'
  Routes::ProductRoutes.draw self, 'national'
  get '/au/shopping/*request_path' => 'redirector#shopping'


 # everything needs to go above centres
  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    get 'events/:id/social-share' => 'social_shares#show', as: 'event_social_share', kind: 'event'
    resources :deals, only: [:index]
    get 'deals/:id/social-share' => 'social_shares#show', as: 'deal_social_share', kind: 'deal'
    get 'deals/:retailer_code/:id' => 'deals#show', as: 'deal'
    get 'deals/:campaign_code' => 'deals#index', as: 'campaign'
    resources :movies, only: [:index]
    get 'movies/:id/social-share' => 'social_shares#show', as: 'movie_social_share', kind: 'movie'
    get 'movies/:movie_name/:id' => 'movies#show', as: 'movie'
    resources :notices, only: [:show]
    get 'notices/:id/social-share' => 'social_shares#show', as: 'notice_social_share', kind: 'centre_service_notice'
    resources :stores, only: [:index]
    get 'stores/:category' => 'stores#index', as: 'stores_category'
    get 'stores/:retailer_code/:id' => 'stores#show', as: 'store'
    get 'hours', to: 'centre_hours#show'
    get 'info', to: 'centre_info#show'
    get 'services', to: 'centre_service_details#show'
    get 'canned-searches/:id/social-share' => 'social_shares#show', as: 'canned_search_social_share', kind: 'canned_search'
    get 'search', to: 'search#index', as: 'search'
    get 'products/curation/:slug' => "curations#show"
    Routes::ProductRoutes.draw self, 'centre'
  end

  root 'centres#index'
end
