class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def app_uninstalled
    head :no_content if params['webhook'].nil?
    
    Shop.find_by_uid(params['webhook']['myshopify_domain']).destroy
    
    head :accepted
  end

  def shop_update
    head :no_content if params['webhook'].nil? 
    
    shop = Shop.find_by_uid(params['webhook']['myshopify_domain'])
    shop.api{ ShopifyAPI::Shop.find(:one, :from => "/admin/shop.json", reload: true) }
    
    head :accepted
  end

  def products_create
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end

  def products_update
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end

  def products_delete
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end

  def collections_create
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end

  def collections_update
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end

  def collections_delete
    head :no_content if params['webhook'].nil? 
    
    logger.info params['webhook']
    
    head :accepted
  end
end
