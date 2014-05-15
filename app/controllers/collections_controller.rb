class CollectionsController < ApplicationController
  before_action :set_shop
  before_action :set_type
  
  # POST /collections/
  def create
    @collection = @class.new(collection_params)
    MakeCollectionSortable.call(@collection)
        
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @shop, notice: 'Collection was successfully made sortable.' }
      else
        format.html { redirect_to @shop, notice: 'Failed to make collection sortable.' }
      end
    end
  end
  
  # DELETE /collection/1
  def destroy
    @collection = @class.find(params[:id])
    RemoveSortabilityFromCollection.call(@collection)
    @collection.destroy
    
    respond_to do |format|
      format.html { redirect_to @shop, notice: 'Collection is no longer sortable.' }
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

    def collection_params
      collection_params = params.require(@class.name.underscore).permit(:id, :shop_id)
      return head :bad_request if collection_params[:shop_id] != params[:shop_id]
      collection_params
    end
end
