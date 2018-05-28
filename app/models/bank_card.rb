class BankCard < ApplicationRecord
  acts_as_paranoid

  belongs_to :bank
  belongs_to :user

  has_many :payments, dependent: :destroy
end
