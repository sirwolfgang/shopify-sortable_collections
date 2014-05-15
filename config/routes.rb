Workspace::Application.routes.draw do
    
  get "/sign_out"               => "sessions#destroy", as: :sign_out
  get "/auth/shopify"           => "sessions#create",  as: :omniauth_shopify
  get "/auth/shopify/callback"  => "sessions#create",  as: :omniauth_shopify_callback

  resources :shops, path: '/' do
    post "webhooks/app_uninstalled"
    post "webhooks/shop_update"
    post "webhooks/products_create"
    post "webhooks/products_update"
    post "webhooks/products_delete"
    post "webhooks/collections_create"
    post "webhooks/collections_update"
    post "webhooks/collections_delete"
    resources :smart_collections,  controller: 'collections', type: 'SmartCollection', only: [:create, :destroy]
    resources :custom_collections, controller: 'collections', type: 'CustomCollection', only: [:create, :destroy]
  end
  
end
