class SmartCollection < Collection
  
  def api
    shop.api { ShopifyAPI::SmartCollection.find(self.id) }
  end
end
