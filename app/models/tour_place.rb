class TourPlace < ApplicationRecord
  acts_as_paranoid

  belongs_to :tour
  belongs_to :place
end
