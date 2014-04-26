class Collection < ActiveRecord::Base
  scope :smart_collections,  -> { where(type: 'SmartCollection') }
  scope :custom_collections, -> { where(race: 'CustomCollection') }
end
