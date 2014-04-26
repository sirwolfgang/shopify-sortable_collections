class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :shopify_id
      t.string :shopify_type

      t.timestamps
    end
    add_index :collections, :shopify_id, unique: true
  end
end
