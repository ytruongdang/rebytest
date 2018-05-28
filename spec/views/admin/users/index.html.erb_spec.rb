require "rails_helper"

RSpec.describe "admin/users/index.html.erb", type: :view do
  let(:user) {FactoryGirl.create :user}

  before do
    assign :users, user
    allow(view).to receive(:gravatar_for).and_return true
  end

  context "should index user" do
    before do
      render "admin/users/user.html.erb", user: user
    end
    it {expect(rendered).to include user.name}
    it {expect(rendered).to include user.email}
    it {expect(rendered).to include user.phone}
    it {expect(rendered).to include user.address}
  end

  context "should render new user path" do
    before do
      render
    end
    it {expect(rendered).to include new_admin_user_path}
  end

  context "should render edit user path" do
    before do
      render "admin/users/user.html.erb", user: user
    end
    it {expect(rendered).to include edit_admin_user_path user}
  end

  context "should render delete user path" do
    before do
      render "admin/users/user.html.erb", user: user
    end
    it {expect(rendered).to include admin_user_path user}
  end
end
