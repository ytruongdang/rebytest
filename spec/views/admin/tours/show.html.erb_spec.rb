require "rails_helper"

RSpec.describe "admin/tours/show.html.erb", type: :view do
  let(:tour) {FactoryGirl.create :tour, :small_picture}

  before do
    assign :tour, tour
  end

  context "should show tour" do
    before do
      render
    end
    it {expect(rendered).to include tour.picture.url}
    it {expect(rendered).to include tour.name}
    it {expect(rendered).to include tour.category.name}
    it {expect(rendered).to include tour.duration.to_s}
    it {expect(rendered).to include tour.price_per_person.to_s}
    it {expect(rendered).to include tour.num_people.to_s}
    it {expect(rendered).to include tour.discount.to_s}
    it {expect(rendered).to include tour.description}
  end

  context "should redirect edit tour" do
    before do
      render
    end
    it {expect(rendered).to include edit_admin_tour_path tour}
  end

  context "should redirect delete tour" do
    before do
      render
    end
    it {expect(rendered).to include admin_tour_path tour}
  end
end
