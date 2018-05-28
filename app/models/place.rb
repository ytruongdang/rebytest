class Place < ApplicationRecord
  enum place_type: {region: 0, city: 1, place: 2}

  acts_as_paranoid

  acts_as_tree order: "created_at DESC"

  has_many :tour_places, dependent: :destroy
  has_many :tours, through: :tour_places

  validates :name, presence: true
  validates :picture, presence: true, on: :create
  validates :place_type, presence: true
  validate :picture_size

  mount_uploader :picture, PictureUploader

  scope :popular_desc, ->{left_joins(:tour_places).group(:id)
    .order "COUNT(tour_id) DESC"}

  private
  def picture_size
    if picture.size > Settings.pictures.max_picture_size.megabytes
      errors.add :picture, I18n.t("picture.error_picture_size")
    end
  end
end
