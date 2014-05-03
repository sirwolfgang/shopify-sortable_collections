class CustomCollection < Collection
  
  def shopify
    @shopify ||= self.shop.api do
      if self.id.nil?
        ShopifyAPI::CustomCollection.new
      else
        ShopifyAPI::CustomCollection.find(self.id)
      end
    end
  end
  
  def reload_shopify
    @shopify = self.shop.api do
      if self.id.nil?
        ShopifyAPI::CustomCollection.new
      else
        ShopifyAPI::CustomCollection.find(self.id, reload: true)
      end
    end
  end
  
end