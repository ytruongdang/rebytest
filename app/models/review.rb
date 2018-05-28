class Review < ApplicationRecord
  acts_as_paranoid

  ratyrate_rateable :quality

  belongs_to :user
  belongs_to :tour

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum review_type: [:place, :food, :news]

  scope :order_time_desc, ->{order created_at: :desc}

  validates :review_type, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
