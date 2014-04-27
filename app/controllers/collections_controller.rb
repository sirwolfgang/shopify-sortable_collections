class CollectionsController < ApplicationController
  before_action :set_shop
  before_action :set_type
  before_action :set_collection, only: [:update, :destroy]

  # POST /collections
  # POST /collections.json
  def create
    @collection = @class.new(collection_params)

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @shop, notice: 'Collection was successfully created.' }
        format.json { head :created }
      else
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @shop, notice: 'Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :no_content }
    end
  end

  private
    def set_shop
      @shop = Shop.find(params[:shop_id])
    end
  
    def set_type
      @class = Collection
      @class = params[:type].constantize unless params[:type].empty?
    end
  
    def set_collection
      @collection = @class.find(params[:id])
    end

    def collection_params
      collection_params = params.require(@class.name.underscore).permit(:id, :shop_id)
      return head :bad_request if collection_params[:shop_id] != params[:shop_id]
      collection_params
    end
end
