class CreateCategoryHierarchies < ActiveRecord::Migration[5.0]
  def change
    create_table :category_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end
    add_index :category_hierarchies, [:ancestor_id, :descendant_id],
      unique: true
    add_index :category_hierarchies, [:descendant_id]
  end
end
