class Collection < ActiveRecord::Base
  belongs_to :shop
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(race: 'CustomCollection') }
  validates :shop_id, presence: true
  validate :shopify, on: :create
  
  def method_missing(method, *args)
    unless self.new_record?
      collection = self.api
      return collection.attributes[method] if collection.attributes.include?(method)
    end
    super
  end
  
  def self.new_from_shopify(shop, shopify_collection)
    shopify_collection.class.name.demodulize.constantize.new(id: shopify_collection.attributes[:id], shop_id: shop.id)
  end
    
  private
    def shopify
      if self.api.nil?
        errors.add(:id, "Shopify Collection not found!")
      end
    end
end
