require "rails_helper"

RSpec.describe "users/show.html.erb", type: :view do
  let(:user) {FactoryGirl.create :user}

  before do
    sign_in user
  end

  context "should index user" do
    before do
      render
    end
    it {expect(rendered).to include user.name}
    it {expect(rendered).to include user.email}
    it {expect(rendered).to include user.phone}
    it {expect(rendered).to include user.address}
  end

  context "should render edit user path" do
    before do
      render
    end
    it {expect(rendered).to include edit_user_registration_path}
  end

  context "should render booking path" do
    before do
      render
    end
    it {expect(rendered).to include bookings_path}
  end

  context "should render review path" do
    before do
      render
    end
    it {expect(rendered).to include reviews_path}
  end
end
