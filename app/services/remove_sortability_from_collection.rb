class RemoveSortabilityFromCollection

  def self.call(collection)
    
    base_collection   = collection.parent
    base_collection ||= collection
    
    base_collection.shopify.template_suffix = nil
    base_collection.shopify.handle = base_collection.handle.gsub(base_collection.sort_order, '')
    base_collection.save
    
    base_collection.children.each do |child|
      child.destroy
    end
  end
  
end