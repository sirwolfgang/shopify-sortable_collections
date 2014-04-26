Workspace::Application.routes.draw do
  
  resources :collections

  post "webhooks/app_uninstalled"
  post "webhooks/shop_update"
  post "webhooks/products_create"
  post "webhooks/products_update"
  post "webhooks/products_delete"
  post "webhooks/collections_create"
  post "webhooks/collections_update"
  post "webhooks/collections_delete"
  
  get "/sign_out"               => "sessions#destroy", as: :sign_out
  get "/auth/shopify"           => "sessions#create",  as: :omniauth_shopify
  get "/auth/shopify/callback"  => "sessions#create",  as: :omniauth_shopify_callback

  resources :shops, path: '/'
end
