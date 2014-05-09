class SmartCollection < Collection
  
  def shopify
    @shopify ||= self.shop.api do
      if self.id.nil?
        ShopifyAPI::SmartCollection.new
      else
        ShopifyAPI::SmartCollection.find(self.id)
      end
    end
  end
  
  def reload_shopify
    @shopify = self.shop.api do
      if self.id.nil?
        ShopifyAPI::SmartCollection.new
      else
        ShopifyAPI::SmartCollection.find(self.id, reload: true)
      end
    end
  end
  
end
