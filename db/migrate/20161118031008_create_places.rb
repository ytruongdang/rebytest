class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :picture
      t.integer :place_type
      t.integer :parent_id
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :places, :deleted_at
  end
end
