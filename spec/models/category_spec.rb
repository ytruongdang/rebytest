require "rails_helper"

RSpec.describe Category, type: :model do
  subject {FactoryGirl.create :category}

  context "validates" do
    it {is_expected.to validate_presence_of :name}
  end

  context "associations" do
    it {is_expected.to have_many :tours}
  end
end
