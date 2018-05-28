class RatingCache < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cacheable, polymorphic: true
end
