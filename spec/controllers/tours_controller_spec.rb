require "rails_helper"

RSpec.describe Admin::ToursController, type: :controller do
  let(:first_tour) {FactoryGirl.create :tour, :small_picture}
  let(:user) {FactoryGirl.create :user}
  let(:category) {FactoryGirl.create :category}

  shared_examples "record not found" do
    before do
      get :edit, id: 0
    end
    it {is_expected.to rescue_from ActiveRecord::RecordNotFound}
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    context "render index" do
      before do
        get :index
      end
      it {is_expected.to render_template "index"}
    end
  end

  describe "GET #new" do
    context "render new" do
      before do
        get :new
      end
      it {is_expected.to render_template "new"}
    end
  end

  describe "POST #create" do
    let(:create_params) {
      {
        name: "Jordane Deckow", price_per_person: 68.0,
        description: "Slow-carb brunch viral 8-bit you probably haven't ...",
        num_people: 6, duration: 2, status: "available",
        discount: 82.0,
        picture: "small_picture.jpg",
        rating: 0.0, category_id: category.id,
        tour_dates_attributes: [start_date: "2016-12-13"],
        tour_places_attributes: [place_id: 1]
      }
    }
    context "created tour" do
      before do
        post :create, tour: create_params
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_tour_path Tour.last}
    end

    context "don't create tour" do
      before do
        post :create, tour: {name: ""}
      end
      it {is_expected.to set_flash[:danger]}
      it {is_expected.to render_template "new"}
    end
  end

  describe "GET #edit" do
    context "render edit" do
      before do
        get :edit, id: first_tour
      end
      it {is_expected.to render_template "edit"}
    end

    it_behaves_like "record not found"
  end

  describe "PATCH #update" do
    context "updated tour" do
      before do
        patch :update, id: first_tour.id, tour: {name: "abc"}
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_tour_path first_tour}
    end

    context "don't update tour" do
      before do
        patch :update, id: first_tour.id, tour: {name: ""}
      end
      it {is_expected.to set_flash[:danger]}
      it {is_expected.to render_template "edit"}
    end

    it_behaves_like "record not found"
  end

  describe "DELETE #destroy" do
    context "deleted tour" do
      before do
        delete :destroy, id: first_tour.id
      end
      it {is_expected.to set_flash[:success]}
      it {is_expected.to redirect_to admin_tours_path}
    end

    context "don't delete tour" do
      before do
        allow(Tour).to receive(:find).and_return first_tour
        allow(first_tour).to receive(:destroy).and_return false
        delete :destroy, id: first_tour
      end
      it {is_expected.to set_flash[:danger]}
      it {is_expected.to redirect_to admin_tour_path first_tour}
    end

    it_behaves_like "record not found"
  end
end
