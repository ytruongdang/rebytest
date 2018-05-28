class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :likeable, polymorphic: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :likes, [:likeable_id, :likeable_type]
  end
end
