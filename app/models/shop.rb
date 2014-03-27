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
  
  def method_missing(method, *args)
    shop = ShopifyAPI::Session.temp(self.uid, self.token) { ShopifyAPI::Shop.current }
    return shop.attributes[method] if shop.attributes.include?(method)
    super
  end
  
end
