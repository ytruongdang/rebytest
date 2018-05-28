class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :review_type
      t.string :title
      t.text :content
      t.float :rating, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :tour, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
