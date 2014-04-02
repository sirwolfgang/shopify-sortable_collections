class WebhooksController < ApplicationController
  def app_uninstalled
  end

  def shop_update
    #ShopifyAPI::Shop.find(:one, :from => "/admin/shop.json", reload: true)
  end

  def products_create
  end

  def products_update
  end

  def products_delete
  end

  def collections_create
  end

  def collections_update
  end

  def collections_delete
  end
end
