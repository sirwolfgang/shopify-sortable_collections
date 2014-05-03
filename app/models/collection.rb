class Collection < ActiveRecord::Base
  
  attr_accessor :shopify
  
  belongs_to :shop
  belongs_to :parent, class_name: "Collection"
  has_many :children, class_name: "Collection", foreign_key: :parent_id
  
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(race: 'CustomCollection') }
  
  validates :shop_id, presence: true
  
  after_initialize :load_from_api
  before_create :create_with_api
  before_update :save_with_api

  def load_from_api
    false
  end
  
  def create_with_api
    save_with_api
    self.id = @shopify.id
    self.id.present?
  end
  
  def save_with_api
    false
  end
  
  def copy_shopify_attributes(collection)
    @shopify.attributes = collection.shopify.attributes.except('id', 'published_at', 'updated_at')
  end
  
  def method_missing(method, *args)
    unless @shopify.nil?
      return @shopify.attributes[method] if @shopify.attributes.include?(method)
    end
    super
  end  

  #  # Manually, By best selling, Alphabetically: A-Z, Alphabetically: Z-A, By price: Highest to lowest, By price: Lowest to highest, By date: Newest to oldest, By date: Oldest to newest
  #  # Manually is supported as main/default and not as a secondary type
  #  sort_types = ["best-selling", "alpha-asc", "alpha-desc", "price-desc", "price-asc", "created-desc", "created"] - [self.sort_order]

end


