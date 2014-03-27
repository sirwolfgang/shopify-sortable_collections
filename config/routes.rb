Workspace::Application.routes.draw do
  resources :shops, path: '/'
  
  get "/sign_out"               => "sessions#destroy", as: :sign_out
  get "/auth/shopify"           => "sessions#create",  as: :omniauth_shopify
  get "/auth/shopify/callback"  => "sessions#create",  as: :omniauth_shopify_callback
end
