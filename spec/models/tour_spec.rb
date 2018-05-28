require "rails_helper"

RSpec.describe Tour, type: :model do
  let(:tour) {FactoryGirl.create :tour}

  describe "validates" do
    it {is_expected.to validate_presence_of :discount}
    it {is_expected.to validate_numericality_of(:discount)
      .is_greater_than_or_equal_to(0).is_less_than_or_equal_to 100}
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_presence_of(:picture).on(:create)}
    it {is_expected.to validate_presence_of :category}
    it {is_expected.to validate_presence_of :num_people}
    it {is_expected.to validate_numericality_of(:num_people).is_greater_than 0}
    it {is_expected.to validate_presence_of :price_per_person}
    it {is_expected.to validate_presence_of :duration}
    it {is_expected.to validate_presence_of :description}
    it {expect(Tour.create.errors).to have_key :tour_dates}
    it {expect(Tour.create.errors).to have_key :tour_places}

    context "#picture_size" do
      tour = FactoryGirl.build :tour, :large_picture
      it {expect(tour).not_to be_valid}
    end
  end

  context "associations" do
    it {is_expected.to have_many :reviews}
    it {is_expected.to have_many :tour_dates}
    it {is_expected.to have_many :tour_places}
    it {is_expected.to have_many(:places).through :tour_places}
    it {is_expected.to have_many(:bookings).through :tour_dates}
    it {is_expected.to belong_to :category}
  end

  context "accept nested attribute for tour date" do
    tour_date = Tour.nested_attributes_options[:tour_dates]
    it {is_expected.to accept_nested_attributes_for(:tour_dates)
      .allow_destroy true}
    it {expect(tour_date[:reject_if].call({"start_date" => ""})).to be}
  end

  context "accept nested attribute for tour place" do
    tour_place = Tour.nested_attributes_options[:tour_places]
    it {is_expected.to accept_nested_attributes_for(:tour_places)
      .allow_destroy true}
    it {expect(tour_place[:reject_if].call({"place_id" => ""})).to be}
  end

  context "price between" do
    before do
      @results = Tour.price_between 10, 80
      @result = @results.first
    end
    it {expect(@result.price_per_person).to be >= 10}
    it {expect(@result.price_per_person).to be <= 80}
  end

  context "hotest tour" do
    before do
      @results = Tour.hotest_tours
    end
    it {expect(@results).to be}
  end
end
