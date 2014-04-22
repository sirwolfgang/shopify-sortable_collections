class ActiveResource::Base
  cached_resource
end

ShopifyAPI::SmartCollection.cached_resource.collection_synchronize = true
ShopifyAPI::CustomCollection.cached_resource.collection_synchronize = true
ShopifyAPI::Product.cached_resource.collection_synchronize = true
