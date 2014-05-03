class CustomCollection < Collection
  
  def load_from_api
    @shopify = self.shop.api do
      if self.id.nil?
        ShopifyAPI::CustomCollection.new
      else
        ShopifyAPI::CustomCollection.find(self.id)
      end
    end
    @shopify.present?
  end
  
  def save_with_api
    ## TODO:: Optimize with Dirty Check, Note: ActiveResource/ActiveModel 4.0.0 does not support Dirty
    self.shop.api do
      @shopify.save
      @shopify = ShopifyAPI::CustomCollection.find(self.id, reload: true)
    end
    @shopify.present?
  end
  
end
