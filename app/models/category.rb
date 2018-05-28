class Category < ApplicationRecord
  acts_as_tree order: "created_at DESC"

  acts_as_paranoid

  has_many :tours, dependent: :destroy

  validates :name, presence: true
end
