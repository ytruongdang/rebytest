class CreateBankCards < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_cards do |t|
      t.integer :card_type
      t.string :owner_name
      t.string :card_num
      t.belongs_to :bank, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
