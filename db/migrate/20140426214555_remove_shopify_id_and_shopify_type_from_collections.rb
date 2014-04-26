class RemoveShopifyIdAndShopifyTypeFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :shopify_id, :integer
    remove_column :collections, :shopify_type, :string
  end
end
