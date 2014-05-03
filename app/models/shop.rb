class Shop < ActiveRecord::Base
  delegate :smart_collections, :custom_collections, to: :collections
  include Rails.application.routes.url_helpers
  
  def self.create_with_omniauth(auth)
    shop = create! do |shop|
      shop.uid   = auth["uid"]
      shop.token = auth["credentials"]["token"]
    end
    shop.register_webhooks
    shop
  end

  def self.find_by_omniauth(auth)
    shop = Shop.find_by_uid(auth["uid"])
    return nil if shop.nil?
    
    shop.update(token: auth["credentials"]["token"]) unless shop.token == auth["credentials"]["token"]
    shop
  end

  def api(&block)
    output = nil
    ShopifyAPI::Session.temp(self.uid, self.token) do 
      output = yield
    end
    return output
  end
  
  def collections
    collections = Array.new
    
    ShopifyAPI::SmartCollection.all.each do |shopify_collection|
      new_collection   = SmartCollection.find_by(shop_id: self.id, id: shopify_collection.id)
      new_collection ||= SmartCollection.new(shop_id: self.id, id: shopify_collection.id)
      collections << new_collection
    end
    
    ShopifyAPI::CustomCollection.all.each do |shopify_collection|
      new_collection   = CustomCollection.find_by(shop_id: self.id, id: shopify_collection.id)
      new_collection ||= CustomCollection.new(shop_id: self.id, id: shopify_collection.id)
      collections << new_collection
    end
    
    collections.sort { |x,y| x.title <=> y.title }
  end
  
  def register_webhooks
    self.api do
      ShopifyAPI::Webhook.create(topic: 'shop/update', address: shop_webhooks_shop_update_url(self.id), format: 'json')
      ShopifyAPI::Webhook.create(topic: 'app/uninstalled', address: shop_webhooks_app_uninstalled_url(self.id), format: 'json')

      ShopifyAPI::Webhook.create(topic: 'collections/create', address: shop_webhooks_collections_create_url(self.id), format: 'json')
      ShopifyAPI::Webhook.create(topic: 'collections/update', address: shop_webhooks_collections_update_url(self.id), format: 'json')
      ShopifyAPI::Webhook.create(topic: 'collections/delete', address: shop_webhooks_collections_delete_url(self.id), format: 'json')
    end
  end
  
  def method_missing(method, *args)
    unless self.new_record?
      shop = self.api { ShopifyAPI::Shop.current }
      return shop.attributes[method] if shop.attributes.include?(method)
    end
    super
  end
end
