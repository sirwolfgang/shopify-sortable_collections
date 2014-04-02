Workspace::Application.routes.draw do
  get "webhooks/app_uninstalled"
  get "webhooks/shop_update"
  get "webhooks/products_create"
  get "webhooks/products_update"
  get "webhooks/products_delete"
  get "webhooks/collections_create"
  get "webhooks/collections_update"
  get "webhooks/collections_delete"
  resources :shops, path: '/'
  
  get "/sign_out"               => "sessions#destroy", as: :sign_out
  get "/auth/shopify"           => "sessions#create",  as: :omniauth_shopify
  get "/auth/shopify/callback"  => "sessions#create",  as: :omniauth_shopify_callback
end
