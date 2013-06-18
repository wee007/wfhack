Customerconsole::Application.routes.draw do
  if Rails.env.development?
    resources :styleguides, only: [:index, :show]
    get 'styleguide' => redirect('/styleguides')
  end

  get 'status' => 'health_check/health_check#index', 'checks' => 'cache_and_site'

  resources :centres, :path => '' do
    resources :events, only: [:index, :show]
    resources :deals, only: [:index, :show]
    resources :movies, only: [:index, :show]
    resources :stores, only: [:index, :show]
    resources :products, only: [:index, :show]
    resources :trading_hours, only: [:index]
    member do
      get 'product_stream'
    end
  end

  root 'centres#index'

  # The priority is based upon order of creation: first created -> highest priority.
  #
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
