class Collection < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :parent, class_name: "Collection"
  has_many :children, class_name: "Collection", foreign_key: :parent_id
  
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(type: 'CustomCollection') }
  
  validates :shop_id, presence: true
  
  before_save :save_with_api
  
  def shopify
    raise "Type not specified!"
  end
  
  def reload_shopify
    raise "Type not specified!"
  end
  
  def save_with_api
    ## TODO:: Optimize with Dirty Check, Note: ActiveResource/ActiveModel 4.0.0 does not support Dirty
    self.shop.api { shopify.save }
    self.id = shopify.id
    reload_shopify.present?
  end
  
  def copy_shopify_attributes(collection)
    shopify.attributes = collection.shopify.attributes.except('id', 'published_at', 'updated_at')
  end
  
  def method_missing(method, *args)
    unless self.shop.nil? or self.shopify.nil?
      return shopify.attributes[method] if shopify.attributes.include?(method)
    end
    super
  end  

  #  # Manually, By best selling, Alphabetically: A-Z, Alphabetically: Z-A, By price: Highest to lowest, By price: Lowest to highest, By date: Newest to oldest, By date: Oldest to newest
  #  # Manually is supported as main/default and not as a secondary type
  #  sort_types = ["best-selling", "alpha-asc", "alpha-desc", "price-desc", "price-asc", "created-desc", "created"] - [self.sort_order]

end


