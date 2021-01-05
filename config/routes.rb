Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get  'login/new',             to: 'logins#new', as: :new_login
  get  'login/cookiesrequired', to: 'logins#cookiesrequired', as: :cookiesrequired_login
  post 'login/create',          to: 'logins#create', as: :create_login
  get  'login/create',          to: redirect('/login/new')
  get  'login/destroy',         to: 'logins#destroy', as: :destroy_login

  post 'accounts/verify',       to: 'accounts#verify', as: :verify_account
  get  'accounts/setup/:token', to: 'accounts#setup',  as: :setup_account
  get  'accounts/:id/delete', to: 'accounts#delete',  as: :delete_account
  resources :accounts

  get 'lists/:email', to: 'lists#by_email', constraints: { email: /([\S]+@[\S]+)/ }
  get 'lists/:id/subscriptions', to: 'lists#subscriptions', as: :list_subscriptions
  get 'lists/:id/new_subscription', to: 'lists#new_subscription', as: :new_list_subscription
  get 'lists/:id/delete', to: 'lists#delete',  as: :delete_list
  resources :lists do
    get    'keys',              to: 'keys#index'
    get    'keys/new',          to: 'keys#new', as: :key_new
    get    'keys/:fingerprint', to: 'keys#show', as: :key
    delete 'keys/:fingerprint', to: 'keys#destroy'
    post   'keys',              to: 'keys#create', as: 'key_create'
  end

  resources  :subscriptions do
    member do
      get 'delete'
    end
  end

  root 'accounts#home'
end
