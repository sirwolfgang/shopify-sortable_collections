class SmartCollection < Collection
  
  def load_from_api
    @shopify = self.shop.api do
      if self.id.nil?
        ShopifyAPI::SmartCollection.new
      else
        ShopifyAPI::SmartCollection.find(self.id)
      end
    end
    @shopify.present?
  end
  
  def save_with_api
    ## TODO:: Optimize with Dirty Check, Note: ActiveResource/ActiveModel 4.0.0 does not support Dirty
    self.shop.api do
      @shopify.save
      @shopify = ShopifyAPI::SmartCollection.find(self.id, reload: true)
    end
    @shopify.present?
  end

end
