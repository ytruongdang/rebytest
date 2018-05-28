class Bank < ApplicationRecord
  acts_as_paranoid

  has_many :bank_cards, dependent: :destroy
end
