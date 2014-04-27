class Collection < ActiveRecord::Base
  belongs_to :shop
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(race: 'CustomCollection') }
end
