class WebhooksController < ApplicationController
  before_action :set_shop
  before_action :validate_request 
  skip_before_action :verify_authenticity_token
  
  def app_uninstalled
    # TODO:: Validate with params
    @shop.destroy

    head :accepted
  end

  def shop_update
    # TODO:: Validate with params
    @shop.reload_shopify
    
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
    @shop.reload_shopify_smart_collections
    @shop.reload_shopify_custom_collections
    
    head :accepted
  end

  def collections_update
    @shop.reload_shopify_smart_collections
    @shop.reload_shopify_custom_collections
    
    head :accepted
  end

  def collections_delete
    @shop.reload_shopify_smart_collections
    @shop.reload_shopify_custom_collections
    
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
