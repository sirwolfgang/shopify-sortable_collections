class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :token
      t.string :uid

      t.timestamps
    end
    add_index :shops, :uid, unique: true
  end
end
