class ShopsController < ApplicationController
  before_action :set_shop, only: :show

  # GET /shops
  # GET /shops.json
  def index
    @shops = Shop.all
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
  end

  # GET /shops/new
  def new
  end

  private
    def set_shop
      @shop = Shop.find(params[:id])
    end
end
