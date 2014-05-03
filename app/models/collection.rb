class Collection < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :parent, class_name: "Collection"
  has_many :children, class_name: "Collection", foreign_key: :parent_id
  
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(type: 'CustomCollection') }
  
  validates :shop_id, presence: true
  
  before_create :create_with_api
  before_update :save_with_api
  
  def shopify
    @shopify ||= load_from_api
  end
  
  def load_from_api
    false
  end
  
  def create_with_api
    save_with_api
    self.id = @shopify.id
    self.id.present?
  end
  
  def save_with_api
    ## TODO:: Optimize with Dirty Check, Note: ActiveResource/ActiveModel 4.0.0 does not support Dirty
    shop.api { shopify.save }
    reload_shopify
  end
  
  def reload_shopify
    false
  end
  
  def copy_shopify_attributes(collection)
    shopify.attributes = collection.shopify.attributes.except('id', 'published_at', 'updated_at')
  end
  
  def method_missing(method, *args)
    unless self.shop.nil?
      return shopify.attributes[method] if shopify.attributes.include?(method)
    end
    super
  end  

  #  # Manually, By best selling, Alphabetically: A-Z, Alphabetically: Z-A, By price: Highest to lowest, By price: Lowest to highest, By date: Newest to oldest, By date: Oldest to newest
  #  # Manually is supported as main/default and not as a secondary type
  #  sort_types = ["best-selling", "alpha-asc", "alpha-desc", "price-desc", "price-asc", "created-desc", "created"] - [self.sort_order]

end


