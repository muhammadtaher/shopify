Rails.application.routes.draw do
  resources :stores
  post '/home/get_shop_name', to: "home#get_shop_name"
  get '/home/get_token_page', to: "home#get_token_page"
  post '/home/get_token', to: "home#get_token"
  get "/home/show_product/:product_id", to: "stores#show_product", as: :show_product
  get '/home/new', to: "home#new"
  get '/stores/show_product/:product_id/show_variant/:variant_id', to: "stores#show_variant", as: :show_variant
  get '/stores/show_customer_orders/:customer_id', to:"stores#show_customer_orders", as: :show_customer_orders
  get '/home/show_purchases', to:"home#show_purchases", as: :customers_orders
  root to:'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
