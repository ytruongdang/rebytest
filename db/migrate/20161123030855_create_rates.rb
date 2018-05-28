class CreateRates < ActiveRecord::Migration

  def self.up
    create_table :rates do |t|
      t.belongs_to :rater
      t.belongs_to :rateable, polymorphic: true
      t.float :stars, default: 0.0
      t.string :dimension
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :rates, :rater_id
    add_index :rates, [:rateable_id, :rateable_type]
  end

  def self.down
    drop_table :rates
  end
end
