class TourDate < ApplicationRecord
  acts_as_paranoid

  belongs_to :tour

  has_many :bookings, dependent: :destroy
end
