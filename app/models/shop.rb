class Shop < ActiveRecord::Base
  has_many :collections
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
  
  def shopify_collections
    collections = Array.new
    collections += self.api { ShopifyAPI::SmartCollection.all }
    collections += self.api { ShopifyAPI::CustomCollection.all }
    collections.sort { |x,y| x.attributes[:title] <=> y.attributes[:title] }
  end
  
  def register_webhooks
    self.api do
      ShopifyAPI::Webhook.create(topic: 'shop/update', address: webhooks_shop_update_url, format: 'json')
      ShopifyAPI::Webhook.create(topic: 'app/uninstalled', address: webhooks_app_uninstalled_url, format: 'json')

      ShopifyAPI::Webhook.create(topic: 'products/create', address: webhooks_products_create_url, format: 'json')
      ShopifyAPI::Webhook.create(topic: 'products/update', address: webhooks_products_update_url, format: 'json')
      ShopifyAPI::Webhook.create(topic: 'products/delete', address: webhooks_products_delete_url, format: 'json')

      ShopifyAPI::Webhook.create(topic: 'collections/create', address: webhooks_collections_create_url, format: 'json')
      ShopifyAPI::Webhook.create(topic: 'collections/update', address: webhooks_collections_update_url, format: 'json')
      ShopifyAPI::Webhook.create(topic: 'collections/delete', address: webhooks_collections_delete_url, format: 'json')
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
