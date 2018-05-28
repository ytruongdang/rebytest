require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.create :user}

  context "validates" do
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_length_of(:name).is_at_most 50}
    it {is_expected.to validate_presence_of :phone}
    it {is_expected.to validate_numericality_of :phone}
    it {is_expected.to validate_length_of(:phone).is_at_least(8).is_at_most 11}
  end

  context "associations" do
    it {is_expected.to have_many :likes}
    it {is_expected.to have_many :reviews}
    it {is_expected.to have_many :comments}
    it {is_expected.to have_many :bookings}
    it {is_expected.to have_many :bank_cards}
    it {is_expected.to have_many(:tour_dates).through :bookings}
    it {is_expected.to have_many(:tours).through :tour_dates}
  end

  describe "#current_user?" do
    it {expect(user.current_user? user).to be}
  end

  describe "#liked?" do
    context "user not like" do
      before do
        @comment = mock_model Comment
      end
      it {expect(user.liked? @comment).to be_falsey}
    end
  end

  auth_hash = OmniAuth::AuthHash.new({
    provider: "facebook",
    info: {
      email: "user@example.com",
      name: "User Example"
    }
  })

  describe ".from_omniauth" do
    context "user exist" do
      before do
        @user = User.new email: "user@example.com", phone: "123456789",
          password: "123456", password_confirmation: "123456"
        @user.save
        @omniauth_user = User.from_omniauth auth_hash
      end
      it {expect(@user.email).to eq @omniauth_user.email}
    end
  end

  session_hash = {
    "devise.auth_data" => {
      "email" => "user@example.com",
      "extra" => {
        "raw_info" => {
          "email" => "user@example.com",
        }
      }
    }
  }

  describe ".new_with_session" do
    context "create new user with email facebook" do
      before do
        param = Hash.new
        @user = User.new_with_session param, session_hash
      end
      it {expect(@user.email).to eq session_hash["devise.auth_data"]["email"]}
    end
  end
end
