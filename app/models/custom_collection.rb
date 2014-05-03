class CustomCollection < Collection

  def load_from_api
    raise "Missing Shop" if self.shop.nil?
    self.shop.api do
      if self.id.nil?
        ShopifyAPI::CustomCollection.new
      else
        ShopifyAPI::CustomCollection.find(self.id)
      end
    end
  end
  
  def reload_shopify
    logger.info @shopify
    self.api { ShopifyAPI::CustomCollection.find(self.id, reload: true) }
    logger.info @shopify
  end
  
end