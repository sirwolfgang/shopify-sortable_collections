class SmartCollection < Collection
  
  def load_from_api
    raise "Missing Shop" if self.shop.nil?
    self.shop.api do
      if self.id.nil?
        ShopifyAPI::SmartCollection.new
      else
        ShopifyAPI::SmartCollection.find(self.id)
      end
    end
  end
 
  def reload_shopify
    logger.info @shopify
    self.api { ShopifyAPI::SmartCollection.find(self.id, reload: true) }
    logger.info @shopify
  end
end
