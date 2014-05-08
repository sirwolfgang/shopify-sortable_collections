class MakeCollectionSortable

  def self.call(base_collection)
    # Manually, By best selling, Alphabetically: A-Z, Alphabetically: Z-A, By price: Highest to lowest, By price: Lowest to highest, By date: Newest to oldest, By date: Oldest to newest
    # Manually is supported as main/default and not as a secondary type
    sort_types = ["best-selling", "alpha-asc", "alpha-desc", "price-desc", "price-asc", "created-desc", "created"] - [base_collection.sort_order]
    base_handle = base_collection.handle.gsub(base_collection.sort_order, '')
    
    base_collection.children.each do |child_collection|
      sort_types -= [child_collection.sort_order]
    end
    
    sort_types.each do |current_sort_order|
      new_collection = base_collection.type.constantize.create do |collection|
        collection.shop   = base_collection.shop
        collection.parent = base_collection
        
        collection.copy_shopify_attributes(base_collection)

        collection.shopify.sort_order      = current_sort_order
        collection.shopify.handle          = "#{base_handle}-#{current_sort_order}"
        collection.shopify.template_suffix = "sortable"
      end
    end
  end
  
end