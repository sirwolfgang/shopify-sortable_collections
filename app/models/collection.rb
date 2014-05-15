class Collection < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :parent, class_name: "Collection"
  has_many :children, class_name: "Collection", foreign_key: :parent_id
  
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(type: 'CustomCollection') }
  
  validates :shop_id, presence: true
  
  before_save :save_with_api
  before_destroy :destroy_with_api
  
  def sortable?
    self.children.present? | self.parent.present?
  end
  
  def original?
    self.present.nil?
  end
  
  def generated?
    self.parent.present?
  end
  
  def shopify
    raise "Type not specified!"
  end
  
  def reload_shopify
    raise "Type not specified!"
  end
  
  def save_with_api
    ## TODO:: Optimize with Dirty Check, Note: ActiveResource/ActiveModel 4.0.0 does not support Dirty
    ## TODO:: Error Logging/Handling
    saved = self.shop.api { self.shopify.save }
    self.id = self.shopify.id
    saved
  end
  
  def destroy_with_api
    return self.shop.api { self.shopify.destroy } if generated?
    true
  end
  
  def copy_shopify_attributes(collection)
    self.shopify.attributes = collection.shopify.attributes.except('id', 'published_at', 'updated_at')
  end
  
  def method_missing(method, *args)
    unless self.shop.nil? or self.shopify.nil?
      return self.shopify.attributes[method] if self.shopify.attributes.include?(method) ## TODO:: Handle assignment operations
    end
    super
  end  
  
end


