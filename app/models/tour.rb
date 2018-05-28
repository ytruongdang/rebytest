class Tour < ApplicationRecord
  enum status: {available: true, unavailable: false}

  acts_as_paranoid

  ratyrate_rateable :quality

  belongs_to :category

  has_many :reviews, dependent: :destroy
  has_many :tour_dates, dependent: :destroy
  has_many :tour_places, dependent: :destroy
  has_many :bookings, through: :tour_dates
  has_many :places, through: :tour_places

  accepts_nested_attributes_for :tour_dates, allow_destroy: true,
    reject_if: lambda {|date| date[:start_date].blank?}
  accepts_nested_attributes_for :tour_places, allow_destroy: true,
    reject_if: lambda {|place| place[:place_id].blank?}

  scope :newest_tours, ->{order created_at: :desc}
  scope :hotest_tours, -> do
    left_joins(:bookings).group(:id).order "COUNT(bookings.id) DESC"
  end
  scope :cheapest_tours, ->{order price_per_person: :desc}
  scope :price_between, -> from, to do
    if from.present? && to.present?
      where "price_per_person BETWEEN ? AND ?", from, to
    end
  end
  scope :rating_order, ->rule {order(rating: rule) if rule.present?}
  scope :price_order, ->rule {order(price_per_person: rule) if rule.present?}
  scope :order_created_desc, -> {order created_at: :desc}

  validates :discount, presence: true,
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :name, presence: true
  validates :picture, presence: true, on: :create
  validates :category, presence: true
  validates :num_people, presence: true, numericality: {greater_than: 0}
  validates :price_per_person, presence: true,
    numericality: {greater_than_or_equal_to: 0}
  validates :duration, presence: true, numericality: {greater_than: 0}
  validates :description, presence: true
  validate :must_have_tour_date
  validate :must_have_tour_place
  validate :picture_size

  mount_uploader :picture, PictureUploader

  private
  def must_have_tour_date
    if tour_dates.empty?
      errors.add :tour_dates,
        I18n.t("shared.error_messages.cant_be_empty")
    end
  end

  def must_have_tour_place
    if tour_places.empty?
      errors.add :tour_places,
        I18n.t("shared.error_messages.cant_be_empty")
    end
  end

  def picture_size
    if picture.size > Settings.pictures.max_picture_size.megabytes
      errors.add :picture, I18n.t("picture.error_picture_size")
    end
  end
end
