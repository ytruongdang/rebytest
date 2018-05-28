class Booking < ApplicationRecord
  acts_as_paranoid

  belongs_to :tour_date
  belongs_to :user

  has_one :payment, dependent: :destroy

  before_save :calculate_price

  validates :contact_name, presence: true
  validates :num_tourist, presence: true, numericality: true
  validates :contact_phone, presence: true, numericality: true,
    length: {maximum: 11, minimum: 8}
  validate :check_number_tourrist

  enum status: [:waiting_pay, :paid, :approve, :reject]

  scope :order_desc, ->{order created_at: :desc}

  def calculate_price
    self.total_price = self.total_price -
      self.total_price * self.tour_date.tour.discount / 100
  end

  private
  def check_number_tourrist
    if self.num_tourist > self.tour_date.tour.num_people
      errors.add :booking, I18n.t("error.num_tourist")
    end
  end
end
