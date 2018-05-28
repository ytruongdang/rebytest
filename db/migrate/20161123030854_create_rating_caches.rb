class CreateRatingCaches < ActiveRecord::Migration

  def self.up
    create_table :rating_caches do |t|
      t.belongs_to :cacheable, polymorphic: true
      t.float :avg, default: 0.0
      t.integer :qty, default: 0
      t.string :dimension
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :rating_caches, [:cacheable_id, :cacheable_type]
  end

  def self.down
    drop_table :rating_caches
  end
end
