require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  let(:params) {
    {name: "test", email: "test@gmail.com", phone: "123456789",
      password: "123456", password_confirmation: "123456"}
  }

  before do
    sign_in user
  end

  shared_examples "record not found" do
    before do
      delete :destroy, id: "0"
    end
    it {is_expected.to rescue_from ActiveRecord::RecordNotFound}
  end

  describe "GET #index" do
    context "render index" do
      before do
        get :index
      end
      it {is_expected.to render_template "index"}
    end
  end

  describe "POST #create" do
    context "created user" do
      before do
        post :create, user: params
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_users_path}
    end

    context "don't create user" do
      before do
        post :create, user: {name: ""}
      end
      it {is_expected.to render_template "new"}
    end
  end

  describe "PATCH #update" do
    context "updated admin password" do
      before do
        post :update, id: user.id, user: {name: "abc"}
      end
      it {is_expected.to set_flash[:success]}
    end

    context "update user infomation" do
      before do
        another_user = User.create(params)
        post :update, id: another_user.id, user: {name: "abc"}
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_users_path}
    end

    context "don't update infomation" do
      before do
        post :update, id: user.id, user: {phone: "123"}
      end
      it {is_expected.to render_template "edit"}
    end

    it_behaves_like "record not found"
  end

  describe "DELETE #destroy" do
    context "deleted user" do
      before do
        delete :destroy, id: user.id
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_users_path}
    end

    context "don't delete user" do
      before do
        allow(User).to receive(:find).and_return user
        allow(user).to receive(:destroy).and_return false
        delete :destroy, id: user
      end
      it {is_expected.to set_flash[:danger]}
    end

    it_behaves_like "record not found"
  end
end
