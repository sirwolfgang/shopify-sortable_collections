class Shop < ActiveRecord::Base
  
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
  
  def api
    ShopifyAPI::Session.temp(self.uid, self.token) { ShopifyAPI::Shop.current }
  end
  
  def method_missing(method, *args)
    return api.attributes[method] if api.attributes.include?(method)
    super
  end
  
end
