class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :customer_token
      t.string :charge_token
      t.string :card_token
      t.string :email
      t.belongs_to :booking, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
