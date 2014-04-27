class WebhooksController < ApplicationController
  before_action :set_shop
  before_action :validate_request 
  skip_before_action :verify_authenticity_token
  
  def app_uninstalled
    # TODO:: Validate with @shop
    Shop.find_by_uid(params['webhook']['myshopify_domain']).destroy
    
    head :accepted
  end

  def shop_update
    # TODO:: Validate with @shop
    shop = Shop.find_by_uid(params['webhook']['myshopify_domain'])
    shop.api{ ShopifyAPI::Shop.find(:one, :from => "/admin/shop.json", reload: true) }
    
    head :accepted
  end

  def products_create
    logger.info params['webhook']
    
    head :accepted
  end

  def products_update
    logger.info params['webhook']
    
    head :accepted
  end

  def products_delete
    logger.info params['webhook']
    
    head :accepted
  end

  def collections_create
    @shop.api do
      ShopifyAPI::SmartCollection.find(:all, reload: true)
      ShopifyAPI::CustomCollection.find(:all, reload: true)
    end
    
    head :accepted
  end

  def collections_update
    @shop.api do
      ShopifyAPI::SmartCollection.find(:all, reload: true)
      ShopifyAPI::CustomCollection.find(:all, reload: true)
    end
    
    head :accepted
  end

  def collections_delete
    @shop.api do
      ShopifyAPI::SmartCollection.find(:all, reload: true)
      ShopifyAPI::CustomCollection.find(:all, reload: true)
    end
    
    head :accepted
  end
  
  private
    def set_shop
      @shop = Shop.find(params[:shop_id])
    end
    
    def validate_request
      return head :no_content if params['webhook'].nil?
      # TODO:: Check Request Signature
    end
end
