Rails.application.routes.draw do
  get  'login/new',             to: 'logins#new', as: :new_login
  get  'login/cookiesrequired', to: 'logins#cookiesrequired', as: :cookiesrequired_login
  post 'login/create',          to: 'logins#create', as: :create_login
  get  'login/create',          to: redirect('/login/new')
  get  'login/destroy',         to: 'logins#destroy', as: :destroy_login

  post 'accounts/verify',       to: 'accounts#verify', as: :verify_account
  get  'accounts/setup/:token', to: 'accounts#setup',  as: :setup_account
  get  'accounts/:id/delete', to: 'accounts#delete',  as: :delete_account
  resources :accounts

  get 'lists/:id/edit_subscriptions', to: 'lists#edit_subscriptions', as: :edit_list_subscriptions
  resources :lists do
    get    'keys',              to: 'keys#index'
    get    'keys/new',          to: 'keys#new'
    get    'keys/:fingerprint', to: 'keys#show', as: :key
    delete 'keys/:fingerprint', to: 'keys#destroy'
    post   'keys',              to: 'keys#create', as: 'key_create'
  end
  resources  :subscriptions

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'accounts#home'

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
