class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :parent_id
      t.belongs_to :review, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
