class Shop < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  after_create :register_webhooks
  after_create :reload_shopify

  def self.create_with_omniauth(auth)
    create! do |shop|
      shop.uid   = auth["uid"]
      shop.token = auth["credentials"]["token"]
    end
  end

  def self.find_by_omniauth(auth)
    shop = Shop.find_by_uid(auth["uid"])
    return nil if shop.nil?
    
    shop.update(token: auth["credentials"]["token"]) unless shop.token == auth["credentials"]["token"]
    shop
  end
  
  def shopify
    @shopify ||= load_from_api
  end
  
  def load_from_api
    self.api do
      if self.uid.present? && self.token.present?
        ShopifyAPI::Shop.find(:one, from: "/admin/shop.json", uid: self.uid) 
      end
    end
  end

  def api(&block)
    output = nil
    ShopifyAPI::Session.temp(self.uid, self.token) do 
      output = yield
    end
    return output
  end
  
  def reload_shopify
    logger.info @shopify
    self.api do
      ShopifyAPI::Shop.find(:one, from: "/admin/shop.json", uid: self.uid, reload: true) 
      ShopifyAPI::SmartCollection.find(:all, uid: self.uid, reload: true)
      ShopifyAPI::CustomCollection.find(:all, uid: self.uid, reload: true)
    end
    logger.info @shopify
  end
  
  def collections
    collections = Array.new
    self.api do
      ShopifyAPI::SmartCollection.find(:all, uid: self.uid).each do |shopify_collection|
        new_collection   = SmartCollection.find_by(shop_id: self.id, id: shopify_collection.id)
        new_collection ||= SmartCollection.new(shop_id: self.id, id: shopify_collection.id)
        collections << new_collection
      end

      ShopifyAPI::CustomCollection.find(:all, uid: self.uid).each do |shopify_collection|
        new_collection   = CustomCollection.find_by(shop_id: self.id, id: shopify_collection.id)
        new_collection ||= CustomCollection.new(shop_id: self.id, id: shopify_collection.id)
        collections << new_collection
      end
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
      return shopify.attributes[method] if shopify.attributes.include?(method)
    end
    super
  end
  
end
