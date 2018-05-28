require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  let(:category) {FactoryGirl.create :category}

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
      it {expect(response).to render_template "index"}
    end
  end

  describe "POST #create" do
    context "build children category" do
      let(:parent) {FactoryGirl.create :category}
      before do
        post :create, parent_id: parent.id, category: {name: "abc"}
      end
      it {expect(parent.id).to be > 0}
    end

    context "created category" do
      before do
        post :create, category: {name: "abc"}
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_categories_path}
    end

    context "don't create category" do
      before do
        post :create, category: {name: ""}
      end
      it {is_expected.to set_flash[:danger]}
    end
  end

  describe "PATCH #update" do
    context "updated category" do
      before do
        patch :update, id: category.id, category: {name: "abc"}
      end
      it {is_expected.to set_flash[:success]}
    end

    context "don't update category" do
      before do
        patch :update, id: category.id, category: {name: ""}
      end
      it {is_expected.to set_flash[:danger]}
    end

    it_behaves_like "record not found"
  end

  describe "DELETE #destroy" do
    let!(:category) {FactoryGirl.create :category}

    context "deleted category" do
      before do
        delete :destroy, id: category.id
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_categories_path}
    end

    it_behaves_like "record not found"
  end
end
