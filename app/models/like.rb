class Like < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
