class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.integer :num_tourist
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_address
      t.text :description
      t.float :total_price
      t.integer :status, default: 0
      t.boolean :is_cancel, default: false
      t.belongs_to :tour_date, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
