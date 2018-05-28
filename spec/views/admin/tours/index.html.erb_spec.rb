require "rails_helper"

RSpec.describe "admin/tours/index.html.erb", type: :view do
  let(:tour) {FactoryGirl.create :tour, :small_picture}

  before do
    assign :tours, tour
    @supports = Supports::TourSupport.new tour: @tour
  end

  context "should index tour" do
    before do
      render "admin/tours/tour.html.erb", tour: tour
    end
    it {expect(rendered).to include tour.name}
    it {expect(rendered).to include tour.price_per_person.to_s}
    it {expect(rendered).to include tour.num_people.to_s}
    it {expect(rendered).to include tour.duration.to_s}
    it {expect(rendered).to include tour.discount.to_s}
    it {expect(rendered).to include tour.status}
    it {expect(rendered).to include tour.picture.url}
  end

  context "should redirect tour detail" do
    before do
      render "admin/tours/tour.html.erb", tour: tour
    end
    it {expect(rendered).to include admin_tour_path tour}
  end
end
