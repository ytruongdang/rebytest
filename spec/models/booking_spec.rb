require "rails_helper"

RSpec.describe Booking, type: :model do
  let(:tour) {FactoryGirl.create :tour, :small_picture}
  let(:user) {FactoryGirl.create :user}

  before do
    @booking = FactoryGirl.build(:booking, num_tourist: 111, tour_date_id: 58)
  end

  describe "validates" do
    it {expect(@booking).to validate_presence_of :contact_name}
    it {expect(@booking).to validate_presence_of :contact_phone}
    it {expect(@booking).to validate_numericality_of :contact_phone}
    it {expect(@booking).to validate_length_of(:contact_phone).is_at_least(8).is_at_most 11}

    context "#check_number_tourist" do
      it {expect(@booking).not_to be_valid}
    end
  end

  describe "associations" do
    it {is_expected.to belong_to :tour_date}
    it {is_expected.to belong_to :user}
    it {is_expected.to have_one(:payment).dependent :destroy}
  end

  context "#calculate_price" do
    before do
      @total_price = @booking.calculate_price
    end
    it {expect(@booking.total_price).to eq(@total_price)}
  end
end
