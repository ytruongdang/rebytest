class CreateTourPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :tour_places do |t|
      t.belongs_to :tour, foreign_key: true
      t.belongs_to :place, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
