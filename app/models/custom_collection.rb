class CustomCollection < Collection
  
  def api
    shop.api { ShopifyAPI::CustomCollection.find(self.id) }
  end
end
